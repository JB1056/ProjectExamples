//import './styles.css';

//-universal-variables-------------------------------------------------------//
let JWT = null;
let offenceList = []
let regionList = []
let ageList = []
let genderList = []
let yearList = []
let monthList = []
let monthDefinerList = []
let counter = 0;
let appDiv = document.getElementById("app");
// server domains
let domain = "cab230.hackhouse.sh";
// let domain = "localhost:443";

//-Buttons-------------------------------------------------------------------//
const regButton = document.getElementById("regBtn");
const logButton = document.getElementById("logBtn");
const outButton = document.getElementById("outBtn");
const offButton = document.getElementById("offBtn");
const searchButton = document.getElementById("srchBtn");
const searchBar = document.getElementById("offenceSearchbar");
const filterBtn = document.getElementById("fltrBtn");
const clearBtn = document.getElementById("clrBtn");
const mapGen = document.getElementById("map");
const graphGen = document.getElementById("graph");

//-Disablers-----------------------------------------------------------------//
function elementToggle(buttonID) {
    var x = document.getElementById(buttonID);
    if (x.style.display === "none") {
      x.style.display = "block";
    } else {
      x.style.display = "none";
    }
  }

elementToggle("outBtn");
elementToggle("srchbarpad")
elementToggle("fillcontainer");
filterBtn.disabled = true;
clearBtn.disabled = true;
mapGen.disabled = true;
graphGen.disabled = true;

//-Array/Table-Generators----------------------------------------------------//
function basicTableGenerator(myArray, ordered) {
    let result = "";
    for(let i=0; i<myArray.length; i++) {
        result += "<tr><td>";
            if (ordered === true) {
            const indexVal = i + 1;
            result += indexVal + ". ";
            }
        result += myArray[i] + "</td>";
        result += "</tr>";
    }
    return result;
}

function generateTableHead(table, data) {
    let thead = table.createTHead();
    let row = thead.insertRow();
    let counter = 0;
    for (let key of data) {
        let th = document.createElement("th");
        th.setAttribute("id", `${counter}`)
        if (counter === 0) {
            th.onclick = function () { sortTable(0, 'searchReturn'); };
        } else if (counter === 1){      
            th.onclick = function () { sortNumericTable(1, `searchReturn`); };
        } else if (counter === 2) {      
            th.onclick = function () { sortNumericTable(2, `searchReturn`); }
        } else if (counter === 3) {      
            th.onclick = function () { sortNumericTable(3, `searchReturn`); }
        } let text = document.createTextNode(key);
        th.appendChild(text);
        row.appendChild(th);
        counter += 1;
    }
}
  
function generateTable(table, data) {
    for (let element of data) {
    let row = table.insertRow();
    for (let key in element) {
        let cell = row.insertCell();
        let content = document.createTextNode(element[key]);
        cell.appendChild(content);
    }}
}

function offenceGenerator() {
    fetch(`https://${domain}/offences`)
        .then(function(response) {
            if (response.ok) {
                return response.json();
            }
            throw new Error("Network response was not ok.");
        })
        .then(function(result) {
            
            return offenceList = result.offences;
        })
        .catch(function(error) {
            console.log("There has been a problem with your fetch operation: ",
                            error.message);
        });
}


function sortNumericTable(n, tableID) {
  let table, rows;
  let switching = true;
  let i, x, y;
  let shouldSwitch;
  let switchcount = 0;
  let dir = "asc";
  table = document.getElementById(tableID);
  while (switching) {
    switching = false;
    rows = table.rows;
    for (i = 1; i < (rows.length - 1); i++) {
      shouldSwitch = false;
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      if (dir == "asc") {
        if (Number(x.innerHTML) > Number(y.innerHTML)) {
            shouldSwitch = true;
            break;
        }
      } else if (dir == "desc") {
        if (Number(x.innerHTML) < Number(y.innerHTML)) {
            shouldSwitch = true;
            break;
        }
      }
    } if (shouldSwitch) {
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      switchcount ++; 
    } else {
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}


function sortTable(n, tableID) {
    let table, rows;
    let switching = true;
    let i, x, y;
    let shouldSwitch;
    let dir = "asc";
    let switchcount = 0;
    table = document.getElementById(tableID);
    while (switching) {
      switching = false;
      rows = table.rows;
      for (i = 1; i < (rows.length - 1); i++) {
        shouldSwitch = false;
        x = rows[i].getElementsByTagName("TD")[n];
        y = rows[i + 1].getElementsByTagName("TD")[n];
        if (dir == "asc") {
          if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
            shouldSwitch = true;
            break;
          }
        } else if (dir == "desc") {
          if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
            shouldSwitch = true;
            break;
          }
        }
      } if (shouldSwitch) {
        rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
        switching = true;
        switchcount ++; 
      } else {
        if (switchcount == 0 && dir == "asc") {
          dir = "desc";
          switching = true;
      }
    }
  }
}

function generateAreas(myArray) {
    let areas = new Array;
    for(let i=0; i<myArray.length; i++) {
        areas.push(myArray[i].LGA);
    }
    regionList = areas;
}

function generateAges() {
    ages = new Array("Juvenile", "Adult");
    ageList = ages;
}

function generateGenders() {
    genders = new Array("Male", "Female", "Not Stated");
    genderList = genders;
}

function generateYears() {
    for (let i = 2000; i < 2019; i++){
        let val = i + 1
        yearList.push(val.toString());
    }
}

function generateMonths() {
    let months = {"January" : "1", "February" : "2", "March" : "3", 
                "April" : "4", "May" : "5", "June" : "6", "July" : "7",
                "August" : "8", "September" : "9", "October" : "10",
                "November" : "11", "December" : "12", 1 : "1", 2 : "2",
                3 : "3", 4 : "4", 5 : "5", 6 : "6", 7 : "7", 8 : "8",
                9 : "9", 10 : "10", 11 : "11", 12 : "12"}
                            
    monthList = months;
}

function generateMonthDefiner() {
    let months = new Array ("January", "February", "March", 
        "April", "May", "June", "July", "August", "September", 
        "October", "November", "December");
    monthDefinerList = months;
}

function formatInput(inputID) {
    const input = document.getElementById(inputID).value;
    return input.replace(/\s*,\s*/g, ",");
}

//-form-and-input-functions--------------------------------------------------//
function buildForm(buttonType) {
    let result = '<div id="formWrapper"><form id="credentialForm" name="credentialForm">' +
                    '<div class="credentialsForm">';
    result += '<input type="email" placeholder="email address" id="email" name="email"/>';
    result += '<input type="password" placeholder="password" id="password" name="password"/>';
    // button 0/1 for register/login, rough equate for both numeric and string variants
    if (buttonType == 0) {
        result += '<input type="button" class="formBtn" id="rgstr" name="rgstr"' +
                    ' onclick=registerConfirmation(this.form) value="Register"/>';
    } else if (buttonType == 1) {
        result += '<input type="button" class="formBtn" id="logn" name="logn"' +
                    ' onclick=loginConfirmation(this.form) value="Login"/>';
    }
    result += '</div></form></div>';
    return result;
}

function formCredentials() {
    return `email=${document.getElementById("email").value}` +
    `&password=${document.getElementById("password").value}`;
}

function loginResponse(){
    fetch(`https://${domain}/login`, {
            method: "POST",
            body: formCredentials(),
            headers: {
                "Content-type": "application/x-www-form-urlencoded"
            }
        })
            .then(function(response) {
                if (response.ok) {
                    return response.json();
                } else if (response.status === 401) { 
                    return "Your email or password was incorrect";
                }
                throw new Error("Network response was not ok.");
            })
            .then(function(result) {
                if (result == "Your email or password was incorrect") {
                    alert(result)
                    return;
                } else if (JWT === null) { 
                    JWT = result.token; 
                    // enables other inputs
                    elementToggle("outBtn");
                    elementToggle("logBtn");
                    elementToggle("regBtn");
                    elementToggle("srchbarpad")
                    elementToggle("fillcontainer");
                    alert("You have successfully logged in. \n" +
                    "Please either search for an offence or open the " +
                    "offence list to view available offences")
                    // remain disabled as unable to re-implement
                    mapGen.disabled = true;
                    graphGen.disabled = true;
                    appDiv.innerHTML = "";
                } else if (JWT !== null) {
                    JWT = result.token;                
                    alert("You are already logged in.");
                } else {
                    throw new Error("Could not log in, please try again.");
                }

            })
            .catch(function(error) {
                console.log("There has been a problem with your fetch operation: ", 
                                error.message);
            });
}

function registerConfirmation(form) {
    let regexTest= /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if (regexTest.test(document.getElementById("email").value)) {
        fetch(`https://${domain}/register`, {
            method: "POST",
            body: formCredentials(),
            headers: {
            "Content-type": "application/x-www-form-urlencoded"
            }
        })
            .then(function(response) {
                if (response.ok) {
                    loginResponse();
                    return "You have successfully registered!";
                } if (response.status === 400) {
                    return "This user is already registered.";
                }
                throw new Error("Network response was not ok");
            })
                .then(function(result) {
                alert(result);
                })
                .catch(function(error) {
                console.log("There has been a problem with your fetch operation: ", 
                                error.message);
            });  
    } if (!regexTest.test(document.getElementById("email").value)) {
        alert("You have entered an invalid email address!")
        console.log("failure, invalid email");
        return (false);
    }
}

function loginConfirmation(form) {
    let regexTest= /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if (regexTest.test(document.getElementById("email").value)) {
        loginResponse();
    } else {
        alert("Please enter a valid email");
    }
}

function searchBarResult() {
    
    let searchResult = null;
    searchResult = document.getElementById("offenceSearchbar").value;
    if (searchResult === "") {
        alert("please enter an offence, available offences can be found under" +
                " the offence tab");
    } else if (searchResult !== null) {
        //The parameters of the call
        let getParam = { method: "GET" };
        let head = { Authorization: `Bearer ${JWT}` };
        getParam.headers = head;

        //The URL
        const baseUrl = `https://${domain}/search?`;
        const query = `offence=${searchResult}`;
        const url = baseUrl + query;

        fetch(encodeURI(url),getParam)
            .then(function(response) {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Network response was not ok.");
            })
            .then(function(result) {     
                if (counter <= 1) {
                    generateAreas(result.result);
                    autocomplete(document.getElementById("areaCk"), regionList,
                    "autocomplete-area");
                }

                appDiv.innerHTML = "<table id='searchReturn'></table>";
                let table = document.querySelector("table");
                let data = Object.keys(result.result[0]);
                generateTableHead(table, data);
                generateTable(table, result.result);
                
                // keep disabled due to lack of time after corruption to
                // recreate methods
                filterBtn.disabled = false;
                clearBtn.disabled = false;
            })
            .catch(function(error) {
                    console.log("There has been a problem with your fetch operation: ",
                                    error.message);
                    alert("There was an issue with your search result, please search" +
                            " using an offence from the Offence List")
                    filterBtn.disabled = true;
                    clearBtn.disabled = true;
            });
            document.getElementById("offenceType").innerHTML = searchResult ;   
    }
}

function wipeFilters() {
    if (document.getElementById("areaCk").value !== null){
        document.getElementById("areaCk").value = null;
    } if (document.getElementById("age").value !== null){
        document.getElementById("age").value = null;
    } if (document.getElementById("gender").value !== null){
        document.getElementById("gender").value = null;
    } if (document.getElementById("year").value !== null){
        document.getElementById("year").value = null;
    } if (document.getElementById("month").value !== null){
        document.getElementById("month").value = null;
    }
}

//-button-functionality------------------------------------------------------//

regButton.addEventListener("click", () => {
    appDiv.innerHTML = buildForm(0);
});


logButton.addEventListener("click", () => {
    appDiv.innerHTML = buildForm(1);
});

outButton.addEventListener("click", () => {
    if (JWT !== null) {
        elementToggle("outBtn");
        elementToggle("logBtn");
        elementToggle("regBtn");
        elementToggle("srchbarpad")
        elementToggle("fillcontainer");
        JWT = null;
        appDiv.innerHTML = "";
        wipeFilters();
        alert("You have successfully logged out.")
    } else if (JWT === null) {
        alert("No user is currently logged in.")
    }
});


offButton.addEventListener("click", () => {
    fetch(`https://${domain}/offences`)
    .then(function(response) {
        if (response.ok) {
            return response.json();
        }
        throw new Error("Network response was not ok.");
    })
    .then(function(result) {
        offenceList = result.offences;
        document.getElementById("offenceType").innerHTML = "Offence Filter";
        appDiv.innerHTML = "<table id='offContainer'><thead>" + 
            "<th onclick='sortTable(0, `offContainer`)'>Offence List</th>" + 
            basicTableGenerator(offenceList, false) + "</thead></table>";
        wipeFilters();
        filterBtn.disabled = true;
        clearBtn.disabled = true;
    })
    .catch(function(error) {
        console.log("There has been a problem with your fetch operation: ",
                        error.message);
    });
});

searchButton.addEventListener("click", () => {
    wipeFilters();
    searchBarResult(); 
    searchBar.value = null;
});

searchBar.addEventListener("keydown", () => {
    if (counter < 1) {
        offenceGenerator();
        generateMonths();
        generateMonthDefiner();
        generateAges();
        generateYears();
        generateGenders()
        counter += 1;
    }
    // autocomplete to comeplement searchBar
    autocomplete(document.getElementById("offenceSearchbar"), offenceList,
                    "autocomplete-offences");    
    // attempts to match auto complete to filter
    autocomplete(document.getElementById("age"), ageList,
                    "autocomplete-age");
    autocomplete(document.getElementById("gender"), genderList,
                    "autocomplete-gender");
    autocomplete(document.getElementById("year"), yearList,
                    "autocomplete-year");
    autocomplete(document.getElementById("month"), monthDefinerList,
                    "autocomplete-month");
});

searchBar.addEventListener("keyup", () => {
    if (event.keyCode === 13) {
      searchBarResult();
    }
});

clearBtn.addEventListener("click", () => {
    wipeFilters();

});

function gabi_content(inputString) {
    let element = document.getElementById(inputString);
    let text = element.innerText || element.textContent;
    element.innerHTML = text;
}

filterBtn.addEventListener("click", () => {

    let filter = ""; 
    if (document.getElementById("areaCk").value !== null){
        filter += `&area=${formatInput("areaCk")}`;
    } if (document.getElementById("age").value !== null) {
        filter += `&age=${formatInput("age")}`; 
    } if (document.getElementById("gender").value !== ""){
        filter += `&gender=${formatInput("gender")}`
    } if (document.getElementById("year").value !== null) {
        filter += `&year=${formatInput("year")}`; 
    } if (document.getElementById("month").value !== null){
        // allows the use of both month name and month integers
        const monthInput = document.getElementById('month').value;
        const monthOutput = inputString => 
            inputString.split(",").map(i => monthList[i.trim()]).join(",")
        filter += `&month=${monthOutput(monthInput)}`;
    }
    
    let getParam = { method: "GET" };
    let head = { Authorization: `Bearer ${JWT}` };
    getParam.headers = head;

    const baseUrl = `https://${domain}/search?`;
    const query = `offence=${document.getElementById("offenceType").innerHTML}`;

    const url = baseUrl + query + "&" + filter;

    fetch(encodeURI(url),getParam)
        .then(function(response) {
            if (response.ok) {
                return response.json();
            } 
            throw new Error("Network response was not ok.");
        })
        .then(function(result) {
        
            appDiv.innerHTML = "<table id='searchReturn'></table>";
                let table = document.querySelector("table");
                let data = Object.keys(result.result[0]);
                generateTableHead(table, data);
                generateTable(table, result.result);
        })
        .catch(function(error) {
                alert("There was an issue with your filters, please check" +
                " all values are correct")
                console.log("There has been a problem with your fetch operation: ",
                                error.message);
        }); 
});


//-Autocomplete-functionality------------------------------------------------//


function autocomplete(destination, arr, itemName) {
    let currentFocus;
    destination.addEventListener("input", function(e) {
        let a, b, i, val = this.value;
        closeAllLists();
        if (!val) { return false;}
        currentFocus = -1;
        a = document.createElement("DIV");
        a.setAttribute("id", this.id + itemName);
        a.setAttribute("class", "autocomplete-items");
        this.parentNode.appendChild(a);
        for (i = 0; i < arr.length; i++) {
          if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
             b = document.createElement("DIV");
            b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
            b.innerHTML += arr[i].substr(val.length);
            b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
                b.addEventListener("click", function(e) {
                destination.value = this.getElementsByTagName("input")[0].value;
                closeAllLists();
            });
            a.appendChild(b);
          }
        }
    });

    destination.addEventListener("keydown", function(e) {
        let x = document.getElementById(this.id + itemName);
        if (x) x = x.getElementsByTagName("div");
        if (e.keyCode == 40) {
          currentFocus++;
          addActive(x);
        } else if (e.keyCode == 38) { 
          currentFocus--;
          addActive(x);
        } else if (e.keyCode == 13) {
          e.preventDefault();
          if (currentFocus > -1) {
            if (x) x[currentFocus].click();
          }
        }
    });
    function addActive(x) {
      if (!x) return false;
      removeActive(x);
      if (currentFocus >= x.length) currentFocus = 0;
      if (currentFocus < 0) currentFocus = (x.length - 1);
      x[currentFocus].classList.add("autocomplete-active");
    }
    function removeActive(x) {
      for (let i = 0; i < x.length; i++) {
        x[i].classList.remove("autocomplete-active");
      }
    }
    function closeAllLists(elmnt) {
      let x = document.getElementsByClassName("autocomplete-items");
      for (let i = 0; i < x.length; i++) {
        if (elmnt != x[i] && elmnt != destination) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  } document.addEventListener("click", function (e) {
      closeAllLists(e.target);
  });
  }