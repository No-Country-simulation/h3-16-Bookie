# Bookie

Before running the project, you need to configure the following environment variables, which can be found in the `.env.example` file:

1. **OPEN_AI_API_KEY**: Your OpenAI API key.
2. **AUTH0_DOMAIN**: The domain from your Auth0 configuration.
3. **AUTH0_CLIENT_ID**: The client ID from your Auth0 configuration.
4. **GOOGLE_MAPS_API_KEY**: The client Google Maps key.
5. **URL_DEPLOY_BACKEND**: Url backend.

   

Make sure to add these variables to your `.env` file or configure them in your development environment.

## Steps to Run the Project

### Install Flutter Dependencies:

Once the variables are configured, install the necessary dependencies by running the following command:

```bash
flutter pub get
```

### Run the Project:

With the dependencies installed, you can run the project on a connected emulator or physical device using the following command:

```bash
flutter run
```

#### Verify Everything is Working:
Make sure the application is running correctly. If you see that the application starts without issues and there are no errors in the console, everything is working fine.

### Perform Hot Reload:

For real-time development, it is recommended to use `Hot Reload`. Press F5 to trigger this. This will start the Flutter server and automatically refresh the app on your device or emulator.
