const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const twilio = require('twilio');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// const accountSid = 'ACa5777c0cb15c82a0c955f10457a4f578';
// const authToken = 'b3bfbbe815b9834b54704b226cc35626';
// const verifySid = 'VA2e63fd2d8e5627a1afbbdca92730c344'; 

const client = twilio(accountSid, authToken);

// Send OTP via Twilio Verify Service
app.post('/send-otp', async (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ success: false, error: 'Phone number is required' });

  try {
    const verification = await client.verify.v2
      .services(verifySid)
      .verifications
      .create({ to: phone, channel: 'sms' });

    res.json({ success: true, status: verification.status });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Verify OTP via Twilio Verify Service
app.post('/verify-otp', async (req, res) => {
  const { phone, code } = req.body;
  if (!phone || !code) return res.status(400).json({ success: false, error: 'Phone and OTP code are required' });

  try {
    const verification_check = await client.verify.v2
      .services(verifySid)
      .verificationChecks
      .create({ to: phone, code });

    if (verification_check.status === 'approved') {
      res.json({ success: true, message: 'OTP verified successfully' });
    } else {
      res.json({ success: false, message: 'Invalid OTP' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(3000, () => console.log('Backend running on port 3000'));
