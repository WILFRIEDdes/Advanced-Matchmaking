export default {
    content: [
        "./src/**/*.{js,ts,jsx,tsx}",
        "./index.html",
        "./projet.html",
    ],

    theme: {
        extend: {},
    },
    plugins: [],

    plugins: [
        require("tailwindcss-animate"),
      ],
}

function openModal() {
    document.getElementById("modal").classList.remove("hidden");
  }

  // Fonction pour fermer le modal
  function closeModal() {
    document.getElementById("modal").classList.add("hidden");
  }