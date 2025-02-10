// JavaScript for Modal Functionality
document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById("doctorModal");
  const modalImg = document.getElementById("modalDoctorImage");
  const modalName = document.getElementById("modalDoctorName");
  const modalInfo = document.getElementById("modalDoctorInfo");
  const closeBtn = document.getElementsByClassName("close")[0];

  const doctors = [
    {
      name: "Dr. John Smith",
      image: "images/team1.jpg",
      info: "Dr. John Smith is a renowned cardiologist with over 20 years of experience.",
    },
    {
      name: "Dr. Emily Davis",
      image: "images/team2.jpg",
      info: "Dr. Emily Davis is a leading neurologist known for her research in brain disorders.",
    },
    {
      name: "Dr. Mich Brown",
      image: "images/team3.jpg",
      info: "Dr. Mich Brown is an orthopedic surgeon specializing in sports injuries.",
    },
    {
      name: "Dr. Sarah Wilson",
      image: "images/team4.jpg",
      info: "Dr. Sarah Wilson is a pediatrician dedicated to child healthcare.",
    },
    {
      name: "Dr. David Johnson",
      image: "images/team5.jpg",
      info: "Dr. David Johnson is a general surgeon with expertise in minimally invasive procedures.",
    },
    {
      name: "Dr. Lavend Roy",
      image: "images/team6.jpg",
      info: "Dr. Lavend Roy is a dermatologist focusing on skin cancer treatments.",
    },
  ];

  document.querySelectorAll(".doc-poster").forEach((poster, index) => {
    poster.addEventListener("click", () => {
      const doctor = doctors[index];
      modalImg.src = doctor.image;
      modalName.textContent = doctor.name;
      modalInfo.textContent = doctor.info;
      modal.style.display = "block";
    });
  });

  closeBtn.onclick = function () {
    modal.style.display = "none";
  };

  window.onclick = function (event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  };

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      modal.style.display = "none";
    }
  });
});

// let menubar = document.querySelector("#menu-bars");
// let navbar = document.querySelector(".navbar");

// menubar.onclick = () => {
//   menubar.classList.toggle("fa-times");
//   navbar.classList.toggle("active");
// };
