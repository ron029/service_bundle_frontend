# Service Bundle Frontend

Welcome to the Service Bundle Frontend repository! This is the front-end component of our service-oriented application. This README provides essential information on how to set up, use, and customize the front-end.

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Dependencies](#dependencies)
7. [Service Bundle API](#service-bundle-api)
8. [Customization](#customization)
9. [Contributing](#contributing)
10. [License](#license)

## Overview

The Service Bundle Frontend is a user interface component designed to work seamlessly with the Service Bundle API, providing a user-friendly way for users to access and interact with services, make bookings, and manage their carts.

## Features

- **User-Friendly Interface**: A responsive and intuitive interface for a great user experience.
- **Seamless Integration**: Connects with the Service Bundle API to access and display services, time slots, and user data.
- **Service Booking**: Allows users to browse services, view available time slots, and make bookings.
- **Cart Management**: Users can create and manage carts, add services, and proceed to checkout.
- **Authentication**: Integrates with the Service Bundle API for secure user login and registration.
- **Customization**: Designed for easy customization to adapt to your specific branding and functionality requirements.

## Requirements

Before setting up the Service Bundle Frontend, ensure you have the following dependencies installed on your system:

- [Node.js](https://nodejs.org/) (Version 16.20.2 recommended)
- [npm](https://www.npmjs.com/) (or [Yarn](https://yarnpkg.com/) if preferred)

## Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/ron029/service_bundle_frontend.git
    ```

2. Navigate to the project directory:

    ```bash
    cd service_bundle_frontend
    ```

3. Install project dependencies:

    ```bash
    npm install
    ```

4. Start the development server:

    ```bash
    npm run serve
    ```

Your Service Bundle Frontend is now running and accessible at `http://localhost:8080`.

## Usage

- Access the front end by opening your web browser and visiting `http://localhost:8080`.
- Browse services, add them to your cart, and proceed to checkout.
- Login or register using your credentials if required.

## Dependencies

- **Apollo Client (v3.8.3)**: Used for GraphQL data fetching and state management.
- **Vue.js (v2.6.14)**: The JavaScript framework for building the user interface of the front-end.

You can find more details about these dependencies in the project's `package.json`.

## Service Bundle API

The Service Bundle Frontend relies on the Service Bundle API as its backend service. The API is responsible for providing data, authentication, and other functionalities to the front end. Here are the key details of the API:

- **Name**: [Service Bundle API](https://github.com/ron029/service_bundle_api)
- **Version**: 1
- **Description**: The Service Bundle API (Version 1) is a powerful backend service that offers a comprehensive set of features for managing services, bookings, and user accounts. It provides secure authentication, efficient data retrieval, and seamless integration with the Service Bundle Frontend.

To set up the entire service-oriented application, make sure you also follow the installation and configuration instructions in the [Service Bundle API README](https://github.com/ron029/service_bundle_api).

## Customization

To customize the Service Bundle Frontend for your specific needs:

- Modify HTML, CSS, and JavaScript files to reflect your branding and design.
- Integrate additional features or adapt the interface to your unique requirements.

## Contributing

We welcome contributions to the Service Bundle Frontend. Please follow our [contribution guidelines](CONTRIBUTING.md) if you'd like to contribute to the project.

## License

The Service Bundle Frontend is open-source and licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Thank you for using the Service Bundle Frontend for your service-oriented application. If you have any questions or encounter issues, please open a GitHub issue or reach out to the maintainers.

*Happy coding!*
