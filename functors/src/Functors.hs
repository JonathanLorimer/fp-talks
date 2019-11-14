module Functors where

class Functor (f :: * -> *) where
  fmap :: (a -> b) -> f a -> f b

data Identity a =
  Identity Int a

-- Breaks identity
instance Functor Identity where
  fmap f (Identity i a) = Identity (i + 1) a

-- | Identity
fmap id == id

-- | Composition
fmap f . fmap g == fmap (f . g)

data Tuple a = Tuple (a,a)
-- | * -> *

data Tuple' a b = Tuple' (a, b)
-- | * -> * -> *

instance Functor (s -> (a, s)) where
  fmap f state = \s1 ->  ap . state $ s1
    where
      ap = \(a, s2) -> (f a, s2)


data Covar b a = Covar { getCovar :: b -> a }

instance Functor (x ->) where
  fmap :: (a -> b) -> (x -> a) -> (x -> b)
  fmap f g = f . g


data Contra a b = Contra { getCovar :: b -> a }

instance Contravariant (-> x) where
  contramap :: (a -> b) -> (b -> x) -> (a -> x)
  contramap f g = g . f

data Predicate a = Predicate { getPred :: a -> Bool }
data Complex a = Complex { getComplex :: (a -> Int) -> Bool













