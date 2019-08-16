function createButton() {
  var button = document.createElement("BUTTON");
  button.innerHTML = "Count";
  document.getElementById("main").appendChild(button);
}

createButton();
