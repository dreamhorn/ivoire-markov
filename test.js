var chai = require('chai');
var Ivoire = require('./lib/ivoire-markov');

chai.should();

describe('ivoire-markov', function () {
  var seed = 42;
  var ivoire;

  beforeEach(function(){
    ivoire = new Ivoire({seed: seed});
  });

  describe('generating random text from a chain', function () {
    it('should generate random text', function () {
      var trained = Ivoire.train_markov_chain(['foo', 'foobar', 'bar', 'baz', 'boo', 'blah', 'boom'], 1);
      var generator = ivoire.get_markov_generator(trained);
      generator.generate().should.equal('bo');
      generator.generate().should.equal('bobobaz');
      generator.generate().should.equal('bar');
      generator.generate().should.equal('foooobo');
      generator.generate().should.equal('boom');
    });
  });
});
