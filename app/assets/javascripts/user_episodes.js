$(document).ready(function(){
        $(".submittable").change(function(){
            $(this).parents('form:first').submit();
    });
});