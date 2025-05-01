# Online Medic System (OMS)

**Online Medic System (OMS)** is a web-based healthcare management platform that integrates four user modules: **Admin**, **Doctor**, **Patient**, and **Emergency Services (Ambulance)**. Through OMS, patients can register and book appointments with doctors or ambulances. Doctors and emergency services can also register on the system and manage their respective appointments. All doctor and emergency service accounts must be verified by an Admin before gaining full access.

## Key Features

- **Multi-Role Access:** Four distinct modules for Admin, Doctor, Patient, and Emergency Service users.
- **Patient Portal:** Patients can sign up, log in, and book or cancel doctor appointments and ambulance services.
- **Doctor Portal:** Doctors can register, log in, and view or manage their scheduled appointments and profile.
- **Emergency (Ambulance) Portal:** Ambulance services can register, log in, and manage ambulance booking requests.
- **Admin Dashboard:** Admin users review and verify new doctor and ambulance service accounts, manage all user records, and view overall appointment details.
- **Appointment Management:** Tracks appointment details (date, time, patient info, fee) and allows editing or cancellation by authorized users.

## Tech Stack

- **Backend:** Java (JSP/Servlets) on Apache Tomcat (Java EE web application). The project uses an Eclipse Dynamic Web Project structure.
- **Database:** MySQL – The database schema (in `sql.txt`) includes tables for `doctor`, `patient`, `admin`, `appointment`, `emergency_service`, and `booking`.
- **Frontend:** HTML5, CSS3, and JavaScript (with [Ionicons](https://ionicons.com/) for icons). Pages are built with JSP files under `src/main/webapp`.
- **Tools:** Built and deployed in Eclipse (Java EE); tested on Apache Tomcat v10.1 (as per project configuration).

## Installation

1. **Clone the Repository:**  
   ```bash
   git clone https://github.com/Deeppati2005/OMS.git
   ```

2. **Prerequisites:** Install [Java JDK](https://www.oracle.com/java/technologies/javase-downloads.html) (Java 8 or higher), [Apache Tomcat](https://tomcat.apache.org/) (v10 or later), and [MySQL](https://www.mysql.com/) on your system.

3. **Setup the Database:**  
   - Create a new MySQL database named `HMS`.  
   - Import the schema by running the SQL statements in `sql.txt` (this creates all necessary tables: `doctor`, `admin`, `patient`, `appointment`, `emergency_service`, `booking`).  
   - (Optional) Insert a default admin record into the `admin` table so you can log in as an administrator.

4. **Configure Database Connection:**  
   - The JSP pages (e.g. `signin.jsp`, dashboards) contain hard-coded MySQL connection settings (URL `jdbc:mysql://localhost:3306/HMS`, username `root`, password `Deep@123`). Edit these lines to match your local database credentials.

5. **Deploy to Tomcat:**  
   - Import the project into Eclipse as a *Dynamic Web Project*, or copy the `OMS` project folder into Tomcat’s `webapps` directory.  
   - Ensure Tomcat is configured (the project’s `.classpath` references Tomcat v10.1).  
   - Start Tomcat and navigate to `http://localhost:8080/OMS/` (if deployed under the `/OMS` context). The welcome page is `index.jsp`.

6. **Run the Application:** The OMS should now be running. You can register new users and log in to use the system as described below.

## Usage

After deployment, open a browser to the application’s URL (e.g. `http://localhost:8080/OMS/`). The home page (`index.jsp`) provides options to register or log in. Use the following steps to use the system:

1. **Register a New Account:** Navigate to `registration.jsp`, select the user role (Patient, Doctor, or Emergency Service), and fill in the required details. Submission creates a new user. Doctors and Emergency Service accounts will be created with status “not verified”.

2. **Log In:** Go to `signin.jsp`, choose your role, and enter your email and password.  
   - **Admin:** Log in with an Admin account (one you inserted into the `admin` table).  
   - **Patient:** A new Patient can log in immediately after registration.  
   - **Doctor/Emergency:** These users must have an Admin-verified account. Unverified logins will fail.

3. **Admin Dashboard:** As Admin, you can view lists of all registered Doctors, Patients, and Emergency Services. From here you can verify (activate) or delete accounts and review appointment records.

4. **Doctor Dashboard:** As a Doctor, view your scheduled appointments and patient details. You can update appointment statuses or cancel appointments if needed.

5. **Emergency Dashboard:** As an Emergency Service user, view and manage ambulance booking requests (with patient name, address, requested time, etc.). You can update the status of each booking.

6. **Patient Dashboard:** As a Patient, book new appointments with doctors (specifying date, time, symptoms) or request an ambulance. You can also view and cancel your existing bookings.

7. **Profile Management:** Each user can edit their profile and change passwords via the provided forms (e.g. `updateProfile.jsp`, `updatepassword.jsp`).

8. **Password Reset:** If you forget your password, use the “Forgot Password” link (`forgotpassword.jsp`), answer your security question, and set a new password on `setpassword.jsp`.

## Contributing

Contributions are welcome! To contribute:  
- Fork this repository and create a new branch for your feature or bugfix.  
- Commit your changes with clear messages and push to your fork.  
- Submit a pull request against the `main` branch explaining your changes.  
- Please follow the existing code style and add comments where appropriate.  
- For large changes or new features, open an issue first to discuss the implementation.

## License

This project does not include an open-source license. (No `LICENSE` file is provided.) You may use or modify the code at your own discretion, or consider adding a license (e.g. MIT, GPL) before distributing it.
