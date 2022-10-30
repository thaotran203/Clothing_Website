<?php

namespace App\Form;

use App\Entity\Product;
use App\Entity\Category;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\Extension\Core\Type\FileType;

class ProductType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('id')
            ->add('Name')
            ->add('Price')
            ->add('Quantity')
            ->add('ImportDate')
            ->add('Description')
            ->add('Image', FileType::class, [
                'label' => 'Product Thumbnail',
                // unmapped means that this field is not associated to any entity property
                'mapped' => false,
                // every time you edit the Product details
                'required' => false
            ]
)
            ->add('Category', 
            EntityType::class, [
                // looks for choices from this entity
                'class' => Category::class,

                // uses the User.username property as the visible option string
                'choice_label' => 'Name'])
                
                

        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Product::class,
        ]);
    }
}
