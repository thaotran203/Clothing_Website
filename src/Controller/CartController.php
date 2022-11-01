<?php

namespace App\Controller;

use App\Entity\Cart;
use App\Entity\Order;
use App\Form\CartType;
use App\Repository\CartRepository;
use App\Repository\ProductRepository;
use App\Repository\ShipmentRepository;
use App\Repository\PaymentRepository;
use App\Repository\OrderDetailRepository;
use App\Repository\OrderRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use App\Entity\User;
use App\Entity\Product;
use Exception;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\ORM\Query;



/**
 * @Route("/cart")
 */
class CartController extends AbstractController
{
    /**
     * @Route("/", name="app_cart_index", methods={"GET"})
     */
    public function index(CartRepository $cartRepository): Response
    {
        return $this->render('cart/index.html.twig', [
            'carts' => $cartRepository->findAll(),
        ]);
    }
     /**
     * @Route("/addCart/{id}", name="app_add_cart", methods={"GET"})
     */
    public function addCart(Product $product, Request $request, CartRepository $cartRepository, ManagerRegistry $mr): Response
    {
        $cart= new Cart();
        $entityManager = $mr->getManager();
        $session = $request->getSession();
        $quantity = (int)$request->query->get('quantity');

        //check if cart is empty
        if (!$session->has('cartElements')) {
            $entityManager->getConnection()->beginTransaction();
            $user = $this->getUser();

            //if it is empty, create an array of pairs (prod Id & quantity) to store first cart element.
            $cartElements = array($product->getId() => $quantity);
            
            //save the array to the session for the first time.
            $session->set('cartElements', $cartElements);
            $cart->setQuantity($quantity);
            $cart->setProduct($product);
            $cart->setUser($user);
            $cartRepository->add($cart, true);

        // flush all new changes (all order details and update order's total) to DB
        $entityManager->flush();

        // Commit all changes if all changes are OK
        $entityManager->getConnection()->commit();
        } else {
            $entityManager->getConnection()->beginTransaction();
            $user = $this->getUser();
            $cartElements = $session->get('cartElements');
            //Add new product after the first time. (would UPDATE new quantity for added product)
            $cartElements = array($product->getId() => $quantity) + $cartElements;
            //Re-save cart Elements back to session again (after update/append new product to shopping cart)
            $session->set('cartElements', $cartElements);
            $cart->setQuantity($quantity);
            $cart->setProduct($product);
            $cart->setUser($user);
            $cartRepository->add($cart, true);
            // flush all new changes (all order details and update order's total) to DB
            $entityManager->flush();
    
            // Commit all changes if all changes are OK
            $entityManager->getConnection()->commit();
        }
        
        // return new Response(); //means 200, successful
        return $this->redirectToRoute('app_review_cart', [], Response::HTTP_SEE_OTHER);
    }

    
    /**
     * @Route("/reviewCart", name="app_review_cart", methods={"GET"})
     */
    public function reviewCart(Request $request, CartRepository $cartRepository): Response
    {
        $user= $this->getUser();  
        $tempQuery = $cartRepository->reviewCart($user);
        return $this->render('cart/cart_review.html.twig', [
            'carts' =>  $tempQuery->getResult(),
        ]);
    }



    /**
     * @Route("/review", name="app_review", methods={"GET"})
     */
    public function review(Request $request): Response
    {
        $session = $request->getSession();
        if ($session->has('cartElements')) {
            $cartElements = $session->get('cartElements');
        } else
            $cartElements = [];
        return $this->json($cartElements);
    }



    /**
     * @Route("/confirm", name="app_confirm", methods={"GET"})
     */
    public function confirm(Request $request, CartRepository $cartRepository, ShipmentRepository $shipmentRepository, ManagerRegistry $mr): Response
    {
        $this->denyAccessUnlessGranted('ROLE_USER');

        $user= $this->getUser();
        $entityManager = $mr->getManager();
        $session = $request->getSession(); //get a session
        $shipment = $request->query->get('shipment');
        $session->set('shipmentID', $shipment);
        $payment = $request->query->get('payment');
        $session->set('paymentID', $payment);

        $tempQuery = $shipmentRepository->getShipmentPrice($shipment);
        $temp = $cartRepository->reviewCart($user);

        return $this->render('cart/checkout.html.twig', [
            'carts' =>  $temp->getResult(),
            'shipments' =>  $tempQuery->getResult(),
            'payment' => $payment,
        ]);
    }


    /**
     * @Route("/checkout", name="app_checkout_cart", methods={"GET"})
     */
    public function checkoutCart(Request $request, PaymentRepository $paymentRepository, ShipmentRepository $shipmentRepository, OrderDetailRepository $orderDetailRepository, OrderRepository $orderRepository, ProductRepository $productRepository, ManagerRegistry $mr): Response
    {
        $this->denyAccessUnlessGranted('ROLE_USER');

        $entityManager = $mr->getManager();
        $session = $request->getSession(); //get a session
        $shipmentID = $session->get('shipmentID');
        $paymentID = $session->get('paymentID');
        $shipment = $shipmentRepository->find($shipmentID);
        $payment = $paymentRepository->find($paymentID);

        // check if session has elements in cart
        if ($session->has('cartElements') && !empty($session->get('cartElements'))) {
        try {
            // start transaction!
            $entityManager->getConnection()->beginTransaction();
            $cartElements = $session->get('cartElements');

            // Create new Order and fill info for it. (Skip Total temporarily for now)
            $order = new Order();
            date_default_timezone_set('Asia/Ho_Chi_Minh');
            $order->setOrderDate(new \DateTime());
            /** @var \App\Entity\User $user */
            $user = $this->getUser();
            $order->setUser($user);
            $order->setShipment($shipment);
            $order->setPayment($payment);

            $orderRepository->add($order, true); //flush here first to have ID in Order in DB.

            // Create all Order Details for the above Order
            $total = 0;
            foreach ($cartElements as $product_id => $quantity) {
            $product = $productRepository->find($product_id);
            // create each Order Detail
            $orderDetail = new OrderDetail();
            $orderDetail->setOrder($order);
            $orderDetail->setProduct($product);
            $orderDetail->setQuantity($quantity);
            $subtotal = $product->getPrice() * $quantity;
            $orderDetail->setSubTotal($subtotal);
            $orderDetailRepository->add($orderDetail);

            // calculate total price
            $total += $subtotal;
        }
            $order->setTotal($total);
            $orderRepository->add($order);

            // flush all new changes (all order details and update order's total) to DB
            $entityManager->flush();

            // Commit all changes if all changes are OK
            $entityManager->getConnection()->commit();

            // Clean up/Empty the cart data (in session) after all.
            $session->remove('cartElements');
        } catch (Exception $e) {
        // If any change above got trouble, we roll back (undo) all changes made above!
        $entityManager->getConnection()->rollBack();
        }
        return new Response("Check in DB to see if the checkout process is successful");
        } else
        return new Response("Nothing in cart to checkout!");
    }



    /**
     * @Route("/new", name="app_cart_new", methods={"GET", "POST"})
     */
    public function new(Request $request, CartRepository $cartRepository): Response
    {
        $session = $request->getSession();
        $cart = new Cart();
        $form = $this->createForm(CartType::class, $cart);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $cartRepository->add($cart, true);

            return $this->redirectToRoute('app_cart_index', [], Response::HTTP_SEE_OTHER);
        }

        return $this->renderForm('cart/new.html.twig', [
            'cart' => $cart,
            'form' => $form,
        ]);
    }

    /**
     * @Route("/{id}", name="app_cart_show", methods={"GET"})
     */
    public function show(Cart $cart): Response
    {
        return $this->render('cart/show.html.twig', [
            'cart' => $cart,
            
        ]);
    }

    /**
     * @Route("/{id}/edit", name="app_cart_edit", methods={"GET", "POST"})
     */
    public function edit(Request $request, Cart $cart, CartRepository $cartRepository): Response
    {
        $form = $this->createForm(CartType::class, $cart);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $cartRepository->add($cart, true);

            return $this->redirectToRoute('app_review_cart', [], Response::HTTP_SEE_OTHER);
        }

        return $this->renderForm('cart/edit.html.twig', [
            'cart' => $cart,
            'form' => $form,
        ]);
    }

    /**
     * @Route("/{id}", name="app_cart_delete", methods={"POST"})
     */
    public function delete(Request $request, Cart $cart, CartRepository $cartRepository): Response
    {
        if ($this->isCsrfTokenValid('delete'.$cart->getId(), $request->request->get('_token'))) {
            $cartRepository->remove($cart, true);
        }

        return $this->redirectToRoute('app_review_cart', [], Response::HTTP_SEE_OTHER);
    }
}