{-# LANGUAGE ConstrainedClassMethods #-}
{-# LANGUAGE NoImplicitPrelude #-}

module AltApplicative where

import Prelude (Functor, fmap)

class Functor f => Applicative f where
    unit :: f ()
    pair :: f a -> f b -> f (a, b)
    pure :: Applicative f => a -> f a
    (<*>) :: f (a -> b) -> f a -> f b

data Basic a = Basic a

data Option a = None | Some a

data Sum a b = This a | That b

data Product a b =
  Product { first  :: a
          , second :: b
          }

data Product' a b c =
  Product' { first'  :: a
           , second' :: b
           , third'  :: c
           }
