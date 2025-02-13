// Helper function to update innerText of an element
function updateElementValue(elementId, value) {
    document.getElementById(elementId).innerText = value;
}

function adjustSliders(changedSlider) {
    const sliders = [
        document.getElementById('slider1'),
        document.getElementById('slider2'),
        document.getElementById('slider3'),
        document.getElementById('slider4')
    ];

    let total = sliders.reduce((sum, slider) => sum + parseInt(slider.value), 0);

    if (total === 100) return; // No need to adjust if the total is already 100

    const delta = total - 100; // How much we need to adjust the other sliders
    const remainingSliders = sliders.filter((_, index) => index !== changedSlider - 1);

    remainingSliders.forEach(slider => {
        const adjustment = Math.round((slider.value / (total - sliders[changedSlider - 1].value)) * delta);
        slider.value = Math.max(0, Math.min(100, parseInt(slider.value) - adjustment)); // Adjust and keep values in bounds
    });

    // Final check to ensure the total is exactly 100
    total = sliders.reduce((sum, slider) => sum + parseInt(slider.value), 0);
    if (total !== 100) {
        sliders[changedSlider - 1].value = parseInt(sliders[changedSlider - 1].value) - (total - 100); // Final adjustment
    }

    updateSliderValues(); // Update the display of slider values
}

function updateSliderValues() {
    updateElementValue('value1', document.getElementById('slider1').value);
    updateElementValue('value2', document.getElementById('slider2').value);
    updateElementValue('value3', document.getElementById('slider3').value);
    updateElementValue('value4', document.getElementById('slider4').value);
}

// Initial call to set the displayed values when the page loads
updateSliderValues();

// New function for updating Jobs and Staff sliders
function updateJobAndStaff() {
    updateElementValue('jobValue', document.getElementById('jobSlider').value);
    updateElementValue('staffValue', document.getElementById('staffSlider').value);
    updateElementValue('capacityValue', document.getElementById('capacitySlider').value);
    updateElementValue('slaValue', document.getElementById('slaSlider').value);
    updateElementValue('freelanceValue', document.getElementById('freelanceSlider').value);
    updateElementValue('flcapValue', document.getElementById('flcapSlider').value);
}

function updateChart() {
  
     const chartContainer = document.getElementById('myChart'); // Assuming your chart is inside a div with this ID

    if (window.hist_values_js.length === 0 || window.bin_edges_js.length === 0) {
        // If histogram data is empty, hide the chart
        myChart.data.datasets[0].data = [window.n_samples_js];
        myChart.data.labels = [0];
    } else {
        // If histogram data is present, show the chart
        myChart.data.datasets[0].data = window.hist_values_js;
        myChart.data.labels = window.bin_edges_js;  
      }
    myChart.update();
}

document.addEventListener("pyscript:ready", updateChart);

const ctx = document.getElementById('myChart').getContext('2d');
const myChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [0], // Example labels
        datasets: [{
            label: 'Simulations',
            data: [], // Example data
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1
        }]
    },
    options: {
        plugins: {
            legend: {
                display: false
            }
        },
        scales: {
            y: { 
              beginAtZero: true,
              grid: {display: false},
              max: 1,
              ticks: {
                precision: 0,
                format: {style: 'percent'}
              },
              title: {
                display: true,
                text: '% of simulations'
              }
            },
            x: {
              beginAtZero: true,
              grid: {display: false},
              max: 10,
              ticks: {
                maxTicksLimit: 6
              },
              title: {
                display: true,
                text: '% breaches'
              }
            },
        }
    }
});
