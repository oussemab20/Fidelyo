// Import necessary modules
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sendgrid = require("@sendgrid/mail");
const otpGenerator = require("otp-generator");  // For OTP generation

// Initialize Firebase Admin SDK
admin.initializeApp();

// Configure SendGrid API Key from Firebase functions config
sendgrid.setApiKey(functions.config().sendgrid.apikey);

// Firebase function to send OTP
exports.sendOtp = functions.https.onRequest(async (request, response) => {
  try {
    // Retrieve email from the request body
    const { email } = request.body;
    if (!email) {
      return response.status(400).send("Email is required.");
    }

    // Generate a 6-digit OTP
    const otp = otpGenerator.generate(6, { upperCase: false, specialChars: false });
    console.log("Generated OTP:", otp);

    // Send OTP email via SendGrid
    const msg = {
      to: email,
      from: "noreply@fidelyo.com",  // Replace with your verified SendGrid sender email
      subject: "Your OTP Code",
      text: `Your OTP code is: ${otp}`,
      html: `<strong>Your OTP code is: ${otp}</strong>`,
    };

    // Send email
    await sendgrid.send(msg);

    // Send success response
    return response.status(200).send("OTP sent successfully!");
  } catch (error) {
    console.error("Error sending OTP:", error);
    return response.status(500).send("Failed to send OTP.");
  }
});
