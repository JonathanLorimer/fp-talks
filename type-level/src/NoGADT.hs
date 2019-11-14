module NoGADT where

data Zero
data Succ n

newtype Vec n a = MkVec { unVec :: [a] }

nil :: Vec Zero a
nil = MkVec []

(.*) :: a -> Vec n a -> Vec (Succ n) a
x .* MkVec xs = MkVec (x : xs)
infix 5 .*

-- | Where it falls short

hd :: Vec (Suc n) -> a
hd (MkVec (x : _xs)) = x
hd (MkVec []) = error "internal error"

vmap :: (a -> b) -> Vec n a -> Vec n b
vmap _ (MkVec []) = []
vmap f (MkVec (x : xs)) = MkVec (f x : unVec (vmap f (MkVec xs)))

