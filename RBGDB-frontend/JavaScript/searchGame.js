
(function () {
    "use strict";

    var searchButton, searchBar;
    var game_id, ESRB, year, gname, Series, studio;

    //http://www.omdbapi.com
    var loadGameData = function () {
        console.log("print");
        var inputData = {
            Gid: game_id,
            s: studio,
            esrb: ESRB,
            name: gname,
            y: year,
            series: Series
        };
        $.ajax({
            url: "searchGame.php",
            type: "GET",
            data: inputData,
            success: function (data) {
                console.log(data);
            },
            fail: function (request, status, error) {
                console.log(error, status, request);
            }
        });
    };

    function displayMovie(data) {

    }

    function getFormData() {
        // title = $('#t').val();
        // year = $('#y').val();
        // responseType = $('[name="response"] option:selected').val();
        // plot = $('[name="plot"] option:selected').val();
        // loadMovieData();
    }


    function resetForm() {
        // $("#search-by-title-response").empty();
    }

    function resetData() {


    }

    function loadGame() {
        console.log("loadGame");
        gname = $('#searchBar').val();
        loadGameData();
    }


    $(document).ready(function () {
        // load in initial state
        searchButton = $(":button").on('click', loadGame);

        console.log("bind");
    });
})();