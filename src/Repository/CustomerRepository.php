<?php

namespace App\Repository;

use App\Entity\Customer;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;
use Doctrine\ORM\Query;
/**
 * @extends ServiceEntityRepository<Customer>
 *
 * @method Customer|null find($id, $lockMode = null, $lockVersion = null)
 * @method Customer|null findOneBy(array $criteria, array $orderBy = null)
 * @method Customer[]    findAll()
 * @method Customer[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class CustomerRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Customer::class);
    }

    public function add(Customer $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Customer $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }
    public function findMore($minPrice, $maxPrice, $Cat,$word): Query
{
$entityManager = $this->getEntityManager();


          
//'SELECT p from App\Entity\Product p
//where p.Category=:Cat AND p.Price >= :minP AND p.Price <= :maxP
//order by p.Price ASC')
//->setParameter('minP', $minPrice)
//->setParameter('maxP', $maxPrice)
//->setParameter('Cat', $Cat);
    $qb = $entityManager->createQueryBuilder();
    $qb->select('p')
    ->from('App:Product','p');
    if(is_null($minPrice)|| empty($minPrice))  {
        $minPrice=0;
    }
    $qb->where('p.Price>='.$minPrice);
    if(!(is_null($maxPrice)|| empty($maxPrice)))  {
        $qb->andWhere('p.Price<='.$maxPrice);
    }
    if(!(is_null($Cat)|| empty($Cat)))  {
            $qb->andWhere('p.Category='.$Cat);
    }
    if(!(is_null($word)|| empty($word))){
        $qb -> andWhere('p.Name like :word') ->setParameter('word','%'.$word.'%');
    }
  
    return $qb->getQuery();
    }

//    /**
//     * @return Customer[] Returns an array of Customer objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('c')
//            ->andWhere('c.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('c.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?Customer
//    {
//        return $this->createQueryBuilder('c')
//            ->andWhere('c.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
