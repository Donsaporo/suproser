/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // Yappy brand colors (TODO: Replace with official hex values when confirmed)
        'yappy-primary': '#00C4B3',
        'yappy-primary-600': '#00A89D', 
        'yappy-primary-700': '#008E85',
        'yappy-blue': '#1E90FF',
        'yappy-contrast': '#FFFFFF',
      },
      boxShadow: {
        'yappy-shadow': '0 4px 14px 0 rgba(0, 196, 179, 0.28)',
      },
      scale: {
        '98': '0.98',
      }
    },
  },
  plugins: [],
};
