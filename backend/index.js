const express = require("express");
const app = express();
const port = 3000;

const OneSignal = require("onesignal-node");
const client = new OneSignal.Client(
  "424b6483-18f2-4010-b01a-d0ff0df91b5d", //appid
  "12313" //apikey
);

app.get("/", (req, res) => res.send("Hello World!"));
app.get("/onesignal", async (req, res) => {
  console.log("test");
  const notification = {
    headings : {"id":"Spengebob"},

    contents: {
        en:"selamat siang welcome",
        id: "selamat siang squidward" 
    },
    // subtitle : {"id":"sub"},
    // include_player_ids: ["1234"]
    include_external_user_ids: ["1234s11"], //external id / private scope
    priority: 10,

    included_segments: [],
    big_picture : "https://m.media-amazon.com/images/M/MV5BNDUwNjBkMmUtZjM2My00NmM4LTlmOWQtNWE5YTdmN2Y2MTgxXkEyXkFqcGdeQXRyYW5zY29kZS13b3JrZmxvdw@@._V1_UX477_CR0,0,477,268_AL_.jpg",
    small_icon: "ic_launcher",
    large_icon : "https://getbootstrap.com/docs/4.1/assets/img/favicons/favicon.ico",
    buttons : [
        {
            "id":"read",
            "text":"read"
        },
        {
            "id":"close",
            "text":"close"
        }
    ]
    // filters: [{ field: "tag", key: "level", relation: ">", value: 10 }],
  };

  try {
    const response = await client.createNotification(notification);
    console.log(response.body.id);
    console.log(response.body);

    if (!response.body.errors) {
      res.json(response.body);
    } else {
      res.json({ err: response.body.errors });
    }
  } catch (e) {
    if (e instanceof OneSignal.HTTPError) {
      // When status code of HTTP response is not 2xx, HTTPError is thrown.
      console.log(e.statusCode);
      console.log(e.body);
    }
  }
});

app.listen(port, () =>
  console.log(`Example app listening at http://localhost:${port}`)
);
