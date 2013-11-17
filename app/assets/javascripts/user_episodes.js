$(document).ready(function(){
    if ($('.submittable').is(':checked')) {
        alert("checked");
    }

        $(".submittable").change(function(){
        $(this).parents('form:first').submit();
    });
});