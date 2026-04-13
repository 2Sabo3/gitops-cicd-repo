document.addEventListener('DOMContentLoaded', () => {
    const colorPicker = document.getElementById('colorPicker');
    const hexDisplay = document.getElementById('hexValue');
    const randomizeBtn = document.getElementById('randomizeBtn');
    
    // Function to apply color
    const applyColor = (color) => {
        document.body.style.backgroundColor = color;
        hexDisplay.textContent = color.toUpperCase();
        colorPicker.value = color;
    };

    // Listen for color changes
    colorPicker.addEventListener('input', (e) => {
        applyColor(e.target.value);
    });

    // Randomize color function
    randomizeBtn.addEventListener('click', () => {
        // Generate random hex color
        const randomColor = '#' + Math.floor(Math.random()*16777215).toString(16).padStart(6, '0');
        applyColor(randomColor);
    });
});
