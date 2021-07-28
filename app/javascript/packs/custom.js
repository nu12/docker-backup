
var toastElList = [].slice.call(document.querySelectorAll('.toast'))
var toastList = toastElList.map(function (toastEl) {
    return new bootstrap.Toast(toastEl)
})

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
})

var check_all = document.getElementById("check-all");
if(check_all){
    check_all.addEventListener("click", (e) => {
        document.querySelectorAll(".form-checkbox").forEach((ch) => {
            ch.checked = e.target.checked
        });
    });
}