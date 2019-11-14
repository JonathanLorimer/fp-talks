---
author: "Jonathan Lorimer"
title: "Toronto Haskell Meetup - Applicatives"
patat:
    wrap: true
    incrementalLists: true
    theme:
        header: [bold, dullYellow]
        bulletList: [dullWhite, dullWhite]
        emph: [bold]
        strong: [bold]
        code: [dullRed, onDullBlack, bold]
        codeBlock: [dullWhite, onDullBlack ]
        syntaxHighlighting:
          string: [dullGreen]
          char: [dullGreen]
          specialChar: [dullCyan]
          verbatimString: [dullGreen]
---

# Applicatives

## A Pattern

```haskell
 $  ::   (a -> b) ->   a ->   b

<$> ::   (a -> b) -> f a -> f b

<*> :: f (a -> b) -> f a -> f b
```

- We are slowly adding layers of structure to our function applications
- We now have to get rid of a layer of structure

- How can we combine structure?
    - Pattern Matching
    - Combining structure (monoid)

## Sum Types

```haskell
class Functor f => Applicative f (* -> *) where
  pure :: f a
  <*>  :: f (a -> b) -> f a -> f b

data Maybe a = Nothing | Just a
data Either a b = Left a | Right b

instance Applicative Maybe where
  pure             = Just
  (<*>) Nothing  _ = Nothing
  (<*>) (Just f) a = f <$> a


instance Applicative (Either a) where
  pure              = Right
  (<*>) (Left a)  _ = Left a
  (<*>) (Right f) a =  f <$> a
```

- For sum types we use pattern matching to eliminate one layer of structure

## Product Types

```haskell
class Functor f => Applicative f (* -> *) where
  pure :: f a
  <*>  :: f (a -> b) -> f a -> f b

data (,) a b = (a,b)

instance Monoid a => Applicative (a,) where
  pure  b           = (mempty, b)
  (<*>) (a, f)  (a',b) = (a <> a', f b)
```

- For product types we use a monoid constraint to combine part of the structure

## Recursive Types

```haskell
class Functor f => Applicative f (* -> *) where
  pure :: f a
  <*>  :: f (a -> b) -> f a -> f b

data [a] = a : ([a] | [])

instance Applicative [a] where
  pure            = (:[])
  (<*>) (f:fs) xs = f <$> xs <> (fs <*> xs)

```

- Again we have to use the monoidal structure of the list to combine it

## Function Types

```haskell
class Functor f => Applicative f (* -> *) where
  pure :: f a
  <*>  :: f (a -> b) -> f a -> f b

newtype Reader a b = Reader { getReader :: a -> b }

instance Applicative (Reader a) where
  pure    a = \r -> a
  (<*>) f g = \r -> f r $ g r
```

- Here we remove part of the structure by applying the function down

## Functoriality

- This is a good exercise for understanding the functoriality of the applicative rather than the monoidal aspect

```haskell
class Functor f => Applicative f where
    unit :: f ()
    pair :: f a -> f b -> f (a, b)
    pure :: Prelude.Applicative f => a -> f a
    (<*>) :: f (a -> b) -> f a -> f b
```

## Basic
```haskell
newtype Basic a = Basic a

instance Functor Basic where
    fmap f (Basic a) = Basic (f a)

instance Applicative Basic where
    unit = Basic ()
    pair (Basic a) (Basic b) = Basic (a, b)
    pure a = fmap (const a) unit
    (<*>) f = fmap (\(f, a) -> f a) . pair f
```
## Sum
```haskell
data Sum a b = First a | Second b

instance Functor (Sum a) where
    fmap _ (First  a) = First a
    fmap f (Second b) = Second (f b)

instance Monoid a => Applicative (Sum a) where
    unit = Second ()
    pair (First  a) (Second b ) = First a
    pair (Second b) (First  a ) = First a
    pair (Second b) (Second b') = Second (b, b')
    pair (First  a) (First  a') = First a
    pure a = fmap (const a) unit
    (<*>) f = fmap (\(f, a) -> f a) . pair f
```

## Product
```haskell
data Product a b = Product a b

instance Functor (Product a) where
    fmap f (Product a b) = Product a (f b)

instance Monoid a => Applicative (Product a) where
    unit = Product mempty ()
    pair (Product a b) (Product a' b') = Product (a `mappend` a) (b, b')
    pure a = fmap (const a) unit
    (<*>) f = fmap (\(f, a) -> f a) . pair f
```

