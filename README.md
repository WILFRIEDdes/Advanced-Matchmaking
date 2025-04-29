# TeamBuilding App

## Description
TeamBuilding is a web application designed to help companies easily create project teams that match specified requirements. It includes a matchmaking system designed to facilitate optimal pairing between users and projects by maximizing compatibility and satisfaction. Our idea is to develop an algorithm that considers users' skills, preferences, and availability, as well as the specific needs of each project.
This system will not only help form well-balanced and high-performing teams, but also ensure an enriching experience for participants and greater efficiency for the projects.

## Prerequisites
Before getting started, make sure the following are installed on your system:
- Python 3.12
- pip (Python's package manager)
- virtualenv (to create an isolated virtual environment)
- docker

## Dependencies
The required dependencies will be installed by following the installation instructions. Among them is the Django web framework, which was used to develop this Python web application.

## Installation

### Clone the Project
First, clone the project repository using the link https://github.com/WILFRIEDdes/Advanced-Matchmaking (or extract the provided zip archive containing the source code):

    git clone https://github.com/WILFRIEDdes/Advanced-Matchmaking.git

Then navigate to the project directory:

    cd Advanced-Matchmaking

### Create and Activate a Virtual Environment
Create your virtual environment using the command:

    python -m venv venv

Then activate it:
On Linux:

    source venv/bin/activate

On Windows:

    venv\Scripts\activate

### Start Docker and install dependencies
Before configuring the database, make sure Docker is running, then execute the following commands to build and start the containers for the database :

    docker build -t advanced-matchmaking .

Then :

    docker-compose up -d

### Install Dependencies
Install the required project dependencies using the requirements.txt file. This will set up all the necessary libraries for the application to work. Navigate to the matchmakingProject directory:

    cd matchmakingProject

Make sure you're still in the virtual environment, then run:

    pip install -r requirements.txt

### Configure the Database
Now, to configure the database you have two options :

- Applying migrations to create the necessary tables. This will create an empty database with the necessary tables. To do so, run the following command:

    python manage.py migrate

Then you'll have to create a superuser :

    python manage.py createsuperuser

You will now be able to access the admin page with this user and create your own users.

- Import the matchmakingDB.sql dump from the mysql-init folder to try out the project with a default database:

    docker exec -i mysql-container mysql -u root -pmonpassword matchmakingDB < ./mysql-init/matchmakingDB.sql

In this case don't forget to use 

    cd ..

to return to the Advanced-Matchmaking directory before executing this command, then return to the matchmakingProject directory for the rest of the installation.

### Run the Application
To test the application, start the server:

    python manage.py runserver

The application will be available at: http://127.0.0.1:8000/matchmakingProject

## How it works
When deploying the application, the admin provides login credentials to a company owner (as a superuser). This owner accesses the Django admin panel to create user accounts for employees, assigning each a role: either employee or manager.

Upon login, the platform detects the user's role and provides access to the corresponding features.

## Features

### Manager Features
- View all projects (ongoing, past, upcoming)
- Assign teams to projects that do not yet have one
- Fill out a satisfaction survey for past projects (demo purpose)
- Create new projects
- View the list of employees
- Edit personal profile:
    - Change password
    - Update skills
    - Set mobility (on-site or remote)
    - Define availability

### Employee Features
- View only the projects they are involved in (ongoing, past, upcoming)
- Edit personal profile (same fields as managers)
- Fill out satisfaction surveys for completed projects