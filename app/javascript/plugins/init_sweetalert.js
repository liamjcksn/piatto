import swal from 'sweetalert'


const initSweetalert = (selector, options = {}, callback = () => {}) => {
  const swalButtons = document.querySelectorAll(selector);
  if (swalButtons) { // protect other pages
    swalButtons.forEach((swalButton) => {
      swalButton.addEventListener('click', (event) => {
        swal(options).then((value) => callback(event, value)); // <-- add the `.then(callback)`
        // console.log(swalButton)
      });
    })
  }
};

export { initSweetalert };
