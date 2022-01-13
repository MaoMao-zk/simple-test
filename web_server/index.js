
const websocket = new WebSocket("ws://10.17.15.30:8765/");

document.getElementById('click1').onclick = () => {
    console.log("asdasdsa")

    websocket.send("haha");
    websocket.onmessage = ({ data }) => {
        console.log("ws recv " + data);
    };
}