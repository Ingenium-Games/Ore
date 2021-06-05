/*

*/

window.addEventListener('DOMContentLoaded', () => {
    var data = window.nuiHandoverData
    var stamp = new Date(data.last * 1000).toLocaleString()
    
    document.querySelector('#Name > span').innerText = data.name;
    document.querySelector('#Lastplayed > span').innerText = stamp;
});

var count = 0;
var thisCount = 0;

const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += [data.type][data.order - 1] || '';
    },

    initFunctionInvoking(data) {
        document.querySelector('.thingy').style.left = '0%';
        document.querySelector('.thingy').style.width = ((data.idx / count) * 100) + '%';
    },

    startDataFileEntries(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += "\u{1f358}";
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector('.thingy').style.left = '0%';
        document.querySelector('.thinyg').style.width = ((thisCount / count) * 100) + '%';
    },

    onLogLine(data) {

    }
};

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});