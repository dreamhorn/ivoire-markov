ivoire-markov
======================

[Markov chains](https://en.wikipedia.org/wiki/Markov_chain) for the
[Ivoire](https://www.npmjs.com/package/ivoire) random number generator
framework.

- [Installing](#installing)
- [Getting Started](#getting-started)
- [Reference](#reference)
- [Acknowledgements](#acknowledgements)


Installing
----------

To install, use `npm`:

    npm install ivoire-markov

Alternately, you can find the source [on Github](https://github.com/dreamhorn/ivoire-markov).


Getting Started
---------------

`ivoire-markov` extends the `ivoire` package. You can require it directly:

    var Ivoire = require('ivoire-markov');

Or you can require it alongside `ivoire`:

    var Ivoire = require('ivoire');
    require('ivoire-markov');


Either way, instantiate and start making chains!

    var i = new Ivoire();
    // Markov chains must be trained on example data.
    var chain = Ivoire.train_markov_chain(['foo', 'bar', 'baz', 'boo', 'blah', 'banana']);

    // We use the trained chain to create a generator from an Ivoire instance:
    var generator = i.get_markov_generator(trained);

    // The generator synthesizes new output from the trained chain, using our
    instance's pseudo-random sequence.  generator.generate()


Reference
---------

`ivoire-markov` adds some methods to the `Ivoire` prototype object,
making them available on all `Ivoire` instances. It also adds methods to the
`Ivoire` "class" object itself, available through the `Ivoire` namespace.


### .train_markov_chain()

#### Syntax

    Ivoire.train_markov_chain(corpus[, lookback])

#### Usage

Train a markov chain on a `corpus` of text, that is, an array of strings,
providing an optional `lookback` distance for the chain.

    var Ivoire = require('ivoire-markov');

    var trained = Ivoire.train_markov_chain(['foo', 'foobar', 'bar', 'baz', 'boo', 'blah', 'boom'], 1);

The `lookback` controls how much context should be considered when generating
text from a chain. `lookback` defaults to 1 if not provided.


### #get_markov_generator()

#### Syntax

    ivoire.get_markov_generator(trained)

#### Usage

Obtain a markov text generator from an Ivoire instance, based on the provided
training data (as returned by `.train_markov_chain()`).

    var Ivoire = require('ivoire-markov');
    var trained = Ivoire.train_markov_chain(['foo', 'foobar', 'bar', 'baz', 'boo', 'blah', 'boom'], 1);
    var ivoire = new Ivoire();

    var generator = ivoire.get_markov_generator(trained);


### generator.generate()

#### Usage

Using the `generator` object obtained from `ivoire.get_markov_generator()`, the
`#generate()` method will return randomized strings that look similar to the
training corpus.

    var Ivoire = require('ivoire-markov');
    var trained = Ivoire.train_markov_chain(['foo', 'foobar', 'bar', 'baz', 'boo', 'blah', 'boom'], 1);
    var ivoire = new Ivoire();
    var generator = ivoire.get_markov_generator(trained);

    console.log(generator.generate());


Acknowledgements
----------------

Markov chain algorithm based on the implementation in
[Darmok](https://github.com/forana/darmok-js), and modified to interoperate
with the Ivoire framework.
