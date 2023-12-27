## Demo App

https://user-images.githubusercontent.com/113328135/236187813-6316bbbd-b9e8-4aa5-bfd8-597ad78dc2a8.mp4

### If you want to further explore this repo or try it for yourself locally make sure to follow these steps.

- This app uses firebase as backend. All faces you register will be stored in the firestore.

1. Make sure you register the app in your firebase, then add the `google-services.json` file in the `android/app/` directory.
2. Enable the **Firestore Database**.
3. In the DB, create a collection name **password**.
4. Add a document with fields *id* and *password* and add a password of your liking.
   #### Refer the image
   ![face auth firestore snap](https://github.com/AslamThachapalli/face-authentication-app/assets/113328135/ce85a675-6e9d-4e27-a1bb-01333347298b)
   ##### Why?
   - After you click **Register User** button, you are routed to an **Enter Password Screen**.
   - In the enter password screen, the password you entered is validated with the password from Firestore.
5. Build the app. You are good to go.

Happy Coding :)
