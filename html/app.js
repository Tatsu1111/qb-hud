const moneyHud = Vue.createApp({
    data() {
        return {
            cash: 0,
            bank: 0,
            amount: 0,
            plus: false,
            minus: false,
            showCash: false,
            showBank: false,
            showUpdate: false,
        };
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            switch (event.data.action) {
                case "showconstant":
                    this.showConstant(event.data);
                    break;
                case "update":
                    this.update(event.data);
                    break;
                case "show":
                    this.showAccounts(event.data);
                    break;
            }
        });
    },
    methods: {
        // CONFIGURE YOUR CURRENCY HERE
        // https://www.w3schools.com/tags/ref_language_codes.asp LANGUAGE CODES
        // https://www.w3schools.com/tags/ref_country_codes.asp COUNTRY CODES
        formatMoney(value) {
            const formatter = new Intl.NumberFormat("en-US", {
                style: "currency",
                currency: "USD",
                minimumFractionDigits: 0,
            });
            return formatter.format(value);
        },
        showConstant(data) {
            this.showCash = true;
            this.showBank = true;
            this.cash = data.cash;
            this.bank = data.bank;
        },
        update(data) {
            this.showUpdate = true;
            this.amount = data.amount;
            this.bank = data.bank;
            this.cash = data.cash;
            this.minus = data.minus;
            this.plus = data.plus;
            if (data.type === "cash") {
                if (data.minus) {
                    this.showCash = true;
                    this.minus = true;
                    setTimeout(() => (this.showUpdate = false), 1000);
                    setTimeout(() => (this.showCash = false), 2000);
                } else {
                    this.showCash = true;
                    this.plus = true;
                    setTimeout(() => (this.showUpdate = false), 1000);
                    setTimeout(() => (this.showCash = false), 2000);
                }
            }
            if (data.type === "bank") {
                if (data.minus) {
                    this.showBank = true;
                    this.minus = true;
                    setTimeout(() => (this.showUpdate = false), 1000);
                    setTimeout(() => (this.showBank = false), 2000);
                } else {
                    this.showBank = true;
                    this.plus = true;
                    setTimeout(() => (this.showUpdate = false), 1000);
                    setTimeout(() => (this.showBank = false), 2000);
                }
            }
        },
        showAccounts(data) {
            if (data.type === "cash" && !this.showCash) {
                this.showCash = true;
                this.cash = data.cash;
                setTimeout(() => (this.showCash = false), 3500);
            } else if (data.type === "bank" && !this.showBank) {
                this.showBank = true;
                this.bank = data.bank;
                setTimeout(() => (this.showBank = false), 3500);
            }
        },
    },
}).mount("#money-container");

const playerHud = {
    data() {
        return {
            health: 0,
            armor: 0,
            hunger: 0,
            tirst: 0,
            voice: 0,
            show: false,
            showHealth: true,
            showArmor: true,
            showHunger: true,
            showThirst: true,
            showVoice: true,
            talking: false,
            talkingColor: "#ffffff",
        };
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            if (event.data.action === "hudtick") {
                this.hudTick(event.data);
            }
        });
    },
    methods: {
        hudTick(data) {
            this.show = data.show;
            this.health = data.health;
            this.armor = data.armor;
            this.hunger = data.hunger;
            this.thirst = data.thirst;
            this.voice = data.voice;
            if (data.talking) {
                this.talkingColor = "#ffff00";
            } else {
                this.talkingColor = "#ffffff";
            }
        },
    },
};

const app = Vue.createApp(playerHud);
app.use(Quasar);
app.mount("#ui-container");

const vehHud = {
    data() {
        return {
            nos: 0,
            fuel: 0,
            show: false,
            speed: 0,
            cruise: 0,
            street1: "",
            street2: "",
            showNos: false,
            seatbelt: 0,
            direction: "",
            cruiseColor: "",
            seatbeltColor: "",
        };
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            if (event.data.action === "car") {
                this.vehicleHud(event.data);
            }
        });
    },
    methods: {
        vehicleHud(data) {
            this.show = data.show;
            this.speed = data.speed;
            this.direction = data.direction;
            this.street1 = data.street1;
            this.street2 = data.street2;
            this.fuel = data.fuel;
            this.nos = data.nos;
            if (data.seatbelt === true) {
                this.seatbelt = 1;
                this.seatbeltColor = "#28a745";
            } else {
                this.seatbelt = 0;
                this.seatbeltColor = "#D64763";
            }
            if (data.cruise === true) {
                this.cruise = 1;
                this.cruiseColor = "#28a745";
            } else {
                this.cruise = 0;
                this.cruiseColor = "#D64763";
            }
            if (data.nos === 0 || data.nos === undefined) {
                this.showNos = false;
            } else {
                this.showNos = true;
            }
            if (data.isPaused === 1) {
                this.show = false;
            }
        },
    },
};
const app2 = Vue.createApp(vehHud);
app2.use(Quasar);
app2.mount("#veh-container");