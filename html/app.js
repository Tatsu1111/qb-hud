const playerHud = {
    data() {
        return {
            health: 0,
            armor: 0,
            hunger: 0,
            tirst: 0,
            stress: 0,
            voice: 0,
            show: false,
            showHealth: true,
            showArmor: true,
            showHunger: true,
            showThirst: true,
            showStress: true,
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
            this.stress = data.stress
            this.thirst = data.thirst;
            this.voice = data.voice;
            if (data.talking) {
                this.talkingColor = "#ae47ff";
            } else {
                this.talkingColor = "#ffffff";
            }
        }
    }
}
const app = Vue.createApp(playerHud);
app.use(Quasar);
app.mount("#container");