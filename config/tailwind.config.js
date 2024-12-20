const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        'roboto-mono': ['Roboto Mono', 'monospace'],
      },
      keyframes: {
        'zoom-rotate': {
          '0%': { transform: 'scale(1) rotate(0deg)' },
          '50%': { transform: 'scale(0.9) rotate(180deg)' },
          '100%': { transform: 'scale(1) rotate(360deg)' },
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
        'zoom-rotate': 'zoom-rotate 1s ease-in-out infinite',
        'rotate-bg': 'rotate-bg 10s linear infinite',
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
