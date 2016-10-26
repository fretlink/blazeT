# blazeT [![Build Status](https://travis-ci.org/johannesgerer/blazeT.svg?branch=master)](https://travis-ci.org/johannesgerer/blazeT) [![Hackage](https://img.shields.io/hackage/v/blazeT.svg)](https://hackage.haskell.org/package/blazeT)

A true monad (transformer) version of the
[blaze-markup](https://hackage.haskell.org/package/blaze-markup) and
[blaze-html](https://hackage.haskell.org/package/blaze-html)
libraries.

# Why?

While blaze's `Markup` and `Html` types have `Monad` instances and can
leverage the the concise `do` notation, they do not satisfy
the
[Monad Laws](https://hackage.haskell.org/package/base-4.8.0.0/docs/Control-Monad.html#t:Monad) and
thus cannot be used as Monads, let alone Monad transformers.

## Use Cases

The `MarkupT` Monad Transformer enables us to write Markup (e.g. HTML)
templates that have access to all those Monads you cannot live without
anymore.

Accessing an environment
([MonadReader](https://hackage.haskell.org/package/mtl-2.2.1/docs/Control-Monad-Reader-Class.html)),
accumulating log or other diagnostic output
([MonadWriter](https://hackage.haskell.org/package/mtl-2.2.1/docs/Control-Monad-Writer-Class.html)),
doing `IO` (like database access) are the first things that come to
mind.

The initial reason of existence of this library is its use
in [Lykah](http://johannesgerer.com/Lykah), which powers my personal
website
[http://johannesgerer.com](http://johannesgerer.com/johannesgerer.com). In
Lykah, the HTML templates have access to the whole site structure (to
build things like menus) and automatically check, insert and keep
track of referenced pages and assets, which turns out to be very
useful for the task of static website generation.

# How to use it?

## Backwards compatible

The library is intended to serve as a drop-in replacement for the
`blaze-markup` and `blaze-html` libraries and should be backwards
compatible:

Simply replace your `module Text.Blaze.*` imports with `module
Text.BlazeT.*` and it should give the same results.

For usage of blaze check out
their [documentation](https://jaspervdj.be/blaze/).

## Unleash the monads



# Implementation

... is located
in
[Text.BlazeT.Internals](https://hackage.haskell.org/package/blazeT/docs/Text-BlazeT-Internals.html).

Everything build around the simple `newtype` definition of the
`MarkupT` transformer, which makes use of the fact that `Blaze.Markup`
is
a
[Monoid](https://hackage.haskell.org/package/base-4.7.0.2/docs/Data-Monoid.html) and
which is basically a `WriterT` transformer writing `Blaze.Markup`:

```Haskell
newtype MarkupT m a = MarkupT { fromMarkupT :: WriterT B.Markup m a }
```

Wrappers used to lift all `Blaze` entities into `BlazeT` are trivially
expressible using basic `WriterT` class methods. Wrapping `Blaze.Markup` is simply `WriterT.tell`:

```Haskell
wrapMarkupT :: Monad m => B.Markup -> MarkupT m ()
wrapMarkupT = tell
```
Wrapping functions that modify `Blaze.Markup` is simply  `WriterT.censor`:

```Haskell
wrapMarkupT2 :: Monad m => (B.Markup -> B.Markup) -> MarkupT m a -> MarkupT m a
wrapMarkupT2 = censor
```

