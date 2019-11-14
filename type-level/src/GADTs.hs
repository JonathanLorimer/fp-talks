{-# LANGUAGE GADTs #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE KindSignatures #-}

module GADTs where

data Zero
data Succ n

data Vec :: * -> * -> * where
  Nil :: Vec Zero a
  (:*) :: a -> Vec n a -> Vec (Succ n) a
deriving instance (Show a) => Show (Vec n a)


-- hd :: Vec (Succ n) a -> a

-- vmap :: (a -> b) -> Vec n a -> Vec n b

-- strange :: Vec Char Int -> Vec (Succ Char) Int

