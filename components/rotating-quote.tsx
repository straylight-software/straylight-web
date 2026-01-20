"use client"

import { useState, useEffect } from "react"

const quotes = [
  "the mythform is usually encountered in one of two modes. one mode assumes that the cyberspace matrix is inhabited, or perhaps visited, by entities whose characteristics correspond with the primary mythoform of a hidden people.",
  "it was the style that mattered and the style was the same. the moderns were mercenaries, practical jokers, nihilistic technofetishists.",
  "all the speed he took, all the turns he'd taken and the corners he'd cut in night city, and still he'd see the matrix in his sleep, bright lattices of logic unfolding across that colorless void...",
  "mirrors, someone had once said, were in some way essentially unwholesome. constructs were more so, she decided.",
  "power, in case's world, meant corporate power. the zaibatsus, the multinationals that shaped the course of human history, had transcended old barriers.",
  "you're always building models. stone circles. cathedrals. pipe-organs. adding machines. i got no idea why i'm here now.",
  "a gothic folly. endless series of chambers linked by passages, by stairwells vaulted like intestines.",
  "senior is wealthy. senior enjoys any number of means of manifestation.",
  "and arranged to become a patron of the aeschmann collection. the aeschmann collection was restricted to the work of psychotics.",
  "he'd always imagined it as a gradual and willing accommodation of the machine, the parent organism. it was the root of street cool too, the knowing posture that implied connection, invisible lines up to hidden levels of influence.",
  "well it feels like i am, kid, but i'm really just a bunch of rom. it's one of them, ah, philosophical questions i guess. but i ain't likely to write you no poem, if you follow me. your ai? it just might. but it ain't no way human.",
]

export function RotatingQuote() {
  const [index, setIndex] = useState(0)
  const [fade, setFade] = useState(true)

  useEffect(() => {
    const interval = setInterval(() => {
      setFade(false)
      setTimeout(() => {
        setIndex((prev) => (prev + 1) % quotes.length)
        setFade(true)
      }, 300)
    }, 3000)

    return () => clearInterval(interval)
  }, [])

  return (
    <p 
      className={`italic text-base02 text-[0.85rem] transition-opacity duration-300 ${fade ? 'opacity-100' : 'opacity-0'}`}
    >
      {quotes[index]}
    </p>
  )
}
