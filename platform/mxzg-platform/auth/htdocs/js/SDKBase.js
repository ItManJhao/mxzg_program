function SDKBase() {

    this.n2ick = "";
    SDKBase.prototype.nick = "SDKBase";
}

var SDK2 = function () {
    SDK2.prototype.nick = "SDK2";
    Object.getPrototypeOf(SDK2.prototype).constructor.call(this);



};
SDK2.prototype = Object.create(SDKBase.prototype);


var test = new SDK2();

document.writeln(test.nick);