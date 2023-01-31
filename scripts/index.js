const loginBtn = document.getElementById("login-btn");

loginBtn.addEventListener("click", () => {
// Connect the user's metamask wallet
if (typeof window.ethereum !== "undefined") {
window.ethereum.enable().then(() => {
console.log("Metamask connected.");
});
}
});