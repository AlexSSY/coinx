const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  safelist: [
    'opacity-0',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        'roboto-mono': ['Roboto Mono', 'monospace'],
        emoji: ['Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji', 'sans-serif'],
      },
      keyframes: {
        'zoom-rotate': {
          '0%': { transform: 'scale(1) rotate(0deg)' },
          '50%': { transform: 'scale(0.9) rotate(180deg)' },
          '100%': { transform: 'scale(1) rotate(360deg)' },
        },
        'zoom-out-in': {
          '0%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(0.8)' },
          '100%': { transform: 'scale(1)' },
        },
        'rotate-bg': {
          '0%': { transform: 'rotate(0deg)' },
          '100%': { transform: 'rotate(360deg)' },
        },
        fadeOut: {
          "0%": { opacity: 1 },
          "100%": { opacity: 0 },
        },
      },
      animation: {
        'spin-slow': 'spin 2s linear infinite',
        'zoom-rotate': 'zoom-rotate 1s',
        'rotate-bg': 'rotate-bg 10s linear infinite',
        'zoom-out-in': 'zoom-out-in 1s linear',
        fade: "fadeOut 4s ease-in-out",
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
