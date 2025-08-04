const functions = require("firebase-functions");
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Inisialisasi Klien Gemini dengan API Key yang aman
const API_KEY = functions.config().gemini.key;
const genAI = new GoogleGenerativeAI(API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-pro" });

// Fungsi yang akan dipanggil dari Flutter
exports.askGemini = functions.https.onCall(async (data, context) => {
  const prompt = data.prompt;
  if (!prompt) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Prompt tidak boleh kosong."
    );
  }

  try {
    const chat = model.startChat();
    const result = await chat.sendMessage(prompt);
    const response = await result.response;
    const text = response.text();

    return { response: text };
  } catch (error) {
    console.error("Error dari Gemini API:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Terjadi kesalahan saat menghubungi Gemini API."
    );
  }
});
