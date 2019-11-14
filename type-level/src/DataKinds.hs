{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE KindSignatures #-}


module DataKinds where

data Nat = Zero | Succ Nat

data Vec :: Nat -> * -> * where
  Nil :: Vec 'Zero a
  (:*) :: a -> Vec n a -> Vec ('Succ n) a
deriving instance (Show a) => Show (Vec n a)

-- strange :: Vec Char Int -> Vec ('Succ Char) Int
-- strange = undefined
