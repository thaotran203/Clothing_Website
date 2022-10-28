<?php

namespace App\Controller;

use App\Entity\Cart;
use App\Form\CartType;
use App\Repository\CartRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use App\Entity\User;
use App\Entity\Product;
use Exception;
use Doctrine\Persistence\ManagerRegistry;
use  Doctrine\ORM\Query;



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
    public function addCart(Product $product, Request $request, CartRepository $cartRepository,
    ManagerRegistry       $mr): Response
    {
        $entityManager = $mr->getManager();
        $session = $request->getSession();
        $quantity = (int)$request->query->get('quantity');
        $cart= new Cart();
        //check if cart is empty
        if (!$session->has('cartElements')) {
            $entityManager->getConnection()->beginTransaction();
            
            
            $user = $this->getUser();
            //if it is empty, create an array of pairs (prod Id & quantity) to store first cart element.
            $cartElements = array($product->getId(), $quantity,$user);
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
            $cartElements = array($product->getId(), $quantity,$user) + $cartElements;
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
        
//        return new Response(); //means 200, successful
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
