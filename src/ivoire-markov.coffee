# Based on https:#github.com/forana/darmok-js/blob/development/src/markov.js
"use strict"

_ = require("lodash")
Ivoire = require('ivoire-weighted-choice')

START = "START"
END = "END"

init_trail = (length) ->
  trail = []
  while (trail.length < length)
    trail.push START
  return trail


# Train a Markov chain on some corpus data.
Ivoire.train_markov_chain = (corpus, lookback) ->
  if lookback is undefined
    lookback = 1
  lookback_distance = lookback + 1
  Ivoire.panic_if corpus.length <= 0, "The provided corpus must contain data!"
  Ivoire.panic_if lookback_distance <= 0, "The lookback distance must be greater than 0!"
  Ivoire.panic_if Math.floor(lookback_distance) != lookback_distance, "The lookback distance must be an integer!"

  matrix =
    sum: 0
    children: {}

  # add each training item to the matrix
  for raw_item in corpus
    trail = init_trail(lookback_distance)

    item = raw_item.split("")
    item.push(END)

    for letter in item
      trail.push(letter)

      while (trail.length > lookback_distance)
        trail = trail.splice(1)

      # dive into matrix, create path along the way
      matrix.sum += 1
      dive = matrix

      for part in trail
        if not dive.children
          dive.children = {}

        if not dive.children.hasOwnProperty(part)
          new_segment =
            sum: 1
          dive.children[part] = new_segment
          dive = new_segment
        else
          segment = dive.children[part]
          segment.sum += 1
          dive = segment

  result =
    matrix: matrix
    lookback: lookback_distance

  return result


Ivoire.prototype.get_markov_generator = (options) ->
  return new Generator this, options


class Generator
  constructor: (@rng, {matrix: @matrix, lookback: @lookback}) ->

  generate: (max_length) ->
    trail = init_trail(@lookback)
    selections = []

    graceful = false
    while (selections.length < max_length || !max_length)
      # trim the trail
      while (trail.length > @lookback - 1)
        trail = trail.splice(1)

      # navigate the matrix
      dive = @matrix
      _.each trail, (part) ->
        dive = dive.children[part]

      # extract sums and values for choice
      values = []
      sums = []
      _.each dive.children, (value, key) ->
        values.push(key)
        sums.push(value.sum)

      # make choice
      choice = @rng.weighted_choice(values, sums)
      # if it's the end keyword, call the word over - otherwise add and continue
      if (choice == END)
        graceful = true
        break
      else
        selections.push(choice)
        trail.push(choice)

    return selections.join("")


module.exports = Ivoire
