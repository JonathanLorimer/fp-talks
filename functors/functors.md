---
author: "Jonathan Lorimer"
title: "Functors"
patat:
    wrap: true
    incrementalLists: true
    theme:
        header: [bold, dullYellow]
        bulletList: [dullWhite, dullWhite]
        emph: [bold]
        strong: [bold]
        code: [vividRed, onDullWhite, bold]
        codeBlock: [dullWhite, onDullBlack ]
        syntaxHighlighting:
          string: [dullGreen]
          char: [dullGreen]
          specialChar: [dullCyan]
          verbatimString: [dullGreen]
---

# Functors

## The Name
- It's an advantage! No prior conceptions.
- We don't call a swan a duckable

## Standard Functor

```haskell
class Functor (f :: * -> *) where
  fmap :: (a -> b) -> f a -> f b
```
- The laws
    - Identity
```haskell
fmap id == id
```
    - Composition
```haskell
fmap (f . g)  ==  fmap f . fmap g
```
- Notice that the kind of a proper functor is unary (Higher Kinded Types)

- At the core fmap is always some sort of transformation

- But it instantiates with different properties for different types
    - List -> Iteration
    - Maybe -> Null Check
    - Map -> Tree Traversal

- This is really a feature of `type classes`, but it presents itself interestingly for functors

- So what is it really? its just an abstraction with behaviour defined by the type, that follows some laws.

## The Function Functor
```haskell
instance Functor ((->) x) where
  fmap :: (a -> b) -> f a -> f b
  fmap f g = f . g
```
- I have trouble seeing the types so I like to specialize them

```haskell
instance Functor (x ->) where
  fmap :: (a -> b) -> (x -> a) -> (x -> b)
  fmap f g = f . g
```

## Contravariance

```haskell
class Contravariant (f :: * -> *) where
  contramap :: (a -> b) -> f b -> f a
```

- The type signture is always weird to me

- The position of the main variable is said to be negative when it is the parameter, and positive when it is the return value
```
(-) -> (+)
```
```haskell
newtype Contra a = Contra (a -> Int)
                           ^
                          (-)
-- | Remember it is the final variable in the type constructor that is important

newtype Contra2 a b c = Contra2 (c -> Int)
```

## Contravariance 2

- These signs can be combined (through the usual laws of multiplication) when functions are nested

```haskell
newtype Covar a = Covar ((a -> Int) -> Int)
                          ^
                         (-)

                         ^--------^
                             (-)

-- | (-) * (-) = (+)

newtype Contra3 a = Contra3 ((Int -> a) -> Int)
                                     ^
                                    (-)

                             ^--------^
                                 (+)
-- | (-) * (+) = (-)
```

## Contravariant Functors
- So, this type can *never* have a Functor instance

```haskell
newtype Contra a = Contra (a -> Int)

instance Functor Contra where
  fmap :: (a -> b) -> f a -> f b
  fmap f (Contra a) = Contra $ ???
```
- That is why we have the `Contravariant` typeclass

```haskell
class Contravariant (f :: * -> *) where
  contramap :: (b -> a) -> f a -> f b
```
```haskell
instance Contravariant (-> x) where
  contramap :: (b -> a) -> (a -> x) -> (b -> x)
  contramap = flip (.)
```
## Contravariant Functors

```haskell
-- | :k (->)    :: * -> * -> *
-- | :k (x ->)  :: * -> *
-- | :k (-> x)  :: * -> *
Functor       (x ->)
Contravariant (-> x)

fmap      :: (a -> b) -> (x -> a) -> (x -> b)
contramap :: (b -> a) -> (a -> x) -> (b -> x)
```
- I found this confusing until I saw some of these types

```haskell
newtype Reader r a  = Reader    { runReader    :: r -> a    }
newtype Predicate a = Predicate { getPredicate :: a -> bool }
```
