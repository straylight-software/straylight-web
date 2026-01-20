"use client"

import React from "react"

import { createContext, useContext, useEffect, useState } from "react"

export type Theme = 
  // Ono-Sendai Dark Series
  | "ono-tuned"
  | "ono-sprawl" 
  | "ono-memphis"
  | "ono-github"
  // MAAS Light Series
  | "maas-neoform"
  | "maas-bioptic"
  | "maas-ghost"
  | "maas-tessier"

interface ThemeContextType {
  theme: Theme
  setTheme: (theme: Theme) => void
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined)

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>("ono-tuned")
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    const stored = localStorage.getItem("straylight-theme") as Theme | null
    if (stored) {
      setTheme(stored)
      document.documentElement.setAttribute("data-theme", stored)
    }
  }, [])

  useEffect(() => {
    if (mounted) {
      localStorage.setItem("straylight-theme", theme)
      document.documentElement.setAttribute("data-theme", theme)
    }
  }, [theme, mounted])

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}

export function useTheme() {
  const context = useContext(ThemeContext)
  if (!context) {
    throw new Error("useTheme must be used within a ThemeProvider")
  }
  return context
}
