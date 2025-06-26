# Card Sharing App

[Live Demo on Heroku](https://boiling-escarpment-56606-6c0e1fde4a01.herokuapp.com)

Most of my work projects are behind the privacy/proprietary wall, so I wanted to split off some (modified) code that I could actually share. It's decidedly "lo-fi", but it's a thing that does a thing—which is what I love to build.

## Features

- Creates a randomly generated member ID and writes it on the card with MiniMagick
- Sends the card via Twilio texting (static image because I'm on the free tier, but normally this would include the randomly generated member ID)
- Emails the card via Mailgun (again, with a static image)
- Hosted on Heroku
