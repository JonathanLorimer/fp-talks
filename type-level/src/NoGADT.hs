module NoGADT where

data Zero
data Succ n

newtype Vec n a = MkVec { unVec :: [a] }

-- nil :: Vec Zero a

-- (.*) :: a -> Vec n a -> Vec (Succ n) a

-- | Where it falls short

-- hd :: Vec (Suc n) -> a

-- vmap :: (a -> b) -> Vec n a -> Vec n b

