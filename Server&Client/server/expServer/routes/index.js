const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const swaggerUI = require('swagger-ui-express');
const swaggerDocument = require('../docs/swagger.json');


/* set swagger as root. */
router.use('/', swaggerUI.serve)
router.get('/', swaggerUI.setup(swaggerDocument))

// register
router.post("/register", (req, res, next) => {
  // check if email is in database
  if (req.body.email == req.db('web_computing.users').where({email: req.body.email}).select('email')) {
    res.status(400).json({message: "Error: email or password does not match"});
    console.log("Error on request", JSON.stringify(req.body));
    } else {
      // salt and hash the password
      bcrypt.hash(req.body.password, 10, (err, hash) => {
        if (err) {
          return res.status(400).json({
            "message": "oops! It looks like that user already exists :("
        });
        } else {
        req.db("users").insert([{email: req.body.email, password: hash}])
        .then(result => {
            console.log(result)
            res.status(201).json({
              message: "User Created"
            });
          })
          .catch(err => {
            console.log(err);
            res.status(400).json({
                "message": "oops! It looks like that user already exists :("
            });
          });
        }
      })
    }
});


// login
router.post("/login", function (req, res, next) {
  if (!req.body.email || !req.body.password) {
  res.status(400).json({message: "Error: email or password does not match"});
  console.log("Error on request", JSON.stringify(req.body));
  } else {
      req.db('web_computing.users').where({email: req.body.email}).select('password')
      .then(function(result) {
          if(!result || !result[0]) {
              res.status(401).json({"message": "invalid login - bad password"})
          } if (bcrypt.compare(req.body.password, result[0].password)) {
            const JWTtoken = jwt.sign({email: result[0].email}, 'secret', {expiresIn: '24'});
            res.status(200).json({"access_token": JWTtoken, "token_type" : "Bearer",
                                    "expires_in": 86400})
          } else {
            res.status(401).json({"message": "invalid login - bad password"})
          }
      })
      .catch(err => {
        console.log(err);
      })
  }
});


// unauthenticated endpoints
router.get("/areas", function(req, res, next){
  req.db.from('web_computing.areas').select("area").pluck("area")
  .then((rows) => {
    res.json({"areas" : rows})
  })
  .catch((err) => {
    console.log(err);
    res.json({"Error" : true, "Message": "Error in MySQL query"})
  })
});

router.get("/ages", function(req, res, next){
  req.db.from('web_computing.offences').select("age").groupBy("age").pluck("age")
  .then((rows) => {
    res.json({"ages" : rows})
  })
  .catch((err) => {
    console.log(err);
    res.json({"Error" : true, "Message": "Error in MySQL query"})
  })
});

router.get("/genders", function(req, res, next){
  req.db.from('web_computing.offences').select("gender").groupBy("gender").pluck("gender")
  .then((rows) => {
    res.json({"genders" : rows})
  })
  .catch((err) => {
    console.log(err);
    res.json({"Error" : true, "Message": "Error in MySQL query"})
  })
});

router.get("/years", function(req, res, next){
  req.db.from('web_computing.offences').select("year").groupBy("year").pluck("year")
  .then((rows) => {
    res.json({"years" : rows})
  })
  .catch((err) => {
    console.log(err);
    res.json({"Error" : true, "Message": "Error in MySQL query"})
  })
});

router.get("/offences", function(req, res, next){
  req.db.from('web_computing.offence_columns').select("pretty").pluck("pretty")
  .then((rows) => {
    res.json({"offences" : rows})
  })
  .catch((err) => {
    console.log(err);
    res.json({"Error" : true, "Message": "Error in MySQL query"})
  })
});


// Authorised Endpoints
// router.get("/search?offence=:offence", function(req, res, next){
//   req.db.select('column').from('offence_columns').where('pretty'. '=', req.query.offence)
//   .then((result) => {
    // for (let i = 0; i < req.db.from('web_computing.areas').select('DATALENGTH(area)'; i++) {
    //   res.json({
    //       "LGA": query to read city names,
    //       "total": query read city names and sum all rows,
    //       "lat": query to read city lat,
    //       "lng": query to read city lng
    //   })
    // }
//   .catch((err) => {
//     console.log(err);
//     res.json({"Error" : true, "Message": "Error in MySQL query"})
//   })
// });

module.exports = router;
