{-# LANGUAGE GADTs #-}
{-# LANGUAGE StandaloneDeriving #-}

module GADTs where

data Zero
data Succ n

data Vec :: Type -> Type -> Type where
  Nil :: Vec Zero a
  (:*) :: a -> Vec n a -> Vec (Succ n) a
deriving instance (Show a) => Show (Vec n a)


hd :: Vec (Succ n) a -> a
hd (x :* _) = x
hd Nil = undefined -- This will give a type error/warning

vmap :: (a -> b) -> Vec n a -> Vec n b
-- vmap Nil = undefined :* Nil | this will not typecheck!
vmap _ Nil = Nil
vmap f (x :* xs) = f x :* vmap f xs

-- | We still have a problem
-- | Nothing prevents this nonsense

strange :: Vec Char Int -> Vec (Succ Char) Int
strange = undefined

