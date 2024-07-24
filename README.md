# GeoLocation Storage Service

The purpose of this service is to store geolocation data extracted through an IP address or a URL.

To achieve this, we use the platform https://ipstack.com as the data provider.

The backend is built with Ruby on Rails, and PostgreSQL is used as the database.

For the project, the following assumptions were made:
- It is possible to register locations based on an IP address or a URL.
- It is possible to list the registered locations based on an IP address or a URL.
- It is possible to query the last registered location based on an IP address or a URL.
- It is possible to delete the last location based on an IP address or a URL.

For the sake of understanding, other alternatives, if the last location was not considered, would be:
- Make the location unique based on the IP address or URL.
- Delete the location based on the IP address or URL.

## Summary
We used the service pattern, where all logic related to an action is delegated to a service.

It's worth highlighting the use of some important gems in the project:

- [Faker](https://github.com/faker-ruby/faker): Used to generate data during testing.
- [Httparty](https://github.com/jnunemaker/httparty): For sending HTTP requests.
- [Jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer): Used as a serializer to format the output of the routes according to the JSON API specification.
- [Dry-validation](https://github.com/dry-rb/dry-validation): Adds a validation layer to the application, allowing validation logic to be extracted from models and placed in contracts.
- [Rswag](https://github.com/rswag/rswag): For generating API documentation.
- [Rspec](https://github.com/rspec/rspec-rails): For writing application tests.
- [Rubocop](https://github.com/rubocop/rubocop): To ensure the application adheres to defined coding standards.
- [Vcr](https://github.com/vcr/vcr): For recording HTTP requests made during tests, thus reducing the use of external resources when testing.

## Running the Application
The application can be run either using Docker or locally on the host machine.

### Using Docker

In the `bin` directory, there are some utility scripts for use with Docker Compose:
- `bin/dev-build`: Builds the application image.
- `bin/dev-console`: Accesses the Rails console.
- `bin/dev-doc`: Generates the application's documentation.
- `bin/dev-exec`: Executes a command in the application container.
- `bin/dev-lint`: Runs RuboCop on the application.
- `bin/dev-start`: Starts the application container in the background.
- `bin/stop`: Stops the application container.
- `bin/test`: Runs the application's tests.
- `bin/up`: Starts the application container in the current terminal.

#### Authentication
For authentication, we chose to validate authorization using a token passed in the header, which is compared with a configured application variable.

Communication with this application requires providing the `Authorization` header in requests, with the value equivalent to the one configured in `SERVICE_ACCESS_KEY` in the `.env` file. For development purposes, the default is `some-hard-token`.

#### Requirements
- Docker
- Docker Compose

#### Running the Application

First, run the command to build the application image:
```
./bin/dev-build
```

After that, create the `.env` file from the `.env-example` file.
All environment variables work as usual, except for `IP_STACK_ACCESS_KEY`, which should be replaced with the token obtained from the https://ipstack.com platform.

Once the `.env` file is created, you can start the application with the command:
```
./bin/dev-start
```

The application will be available at http://localhost:3000.

API documentation will be available at http://localhost:3000/api-docs/index.html.

When using the documentation, for development purposes, the default user is `swagger` and the default password is `swagger`.

By default, the application will be accessible on port 3000, but this can be changed by modifying the port in the `.env` file.

#### Testing the Application

To run the tests, use the command:
```
./bin/dev-test
```
