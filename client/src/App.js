import { useState } from "react"
import "./index.css"
import User from "./User.js"
import Game from "./Game.js"
import AboutMe from "./AboutMe.js"

function App() {
    const [user, setUser] = useState(null)

    return (
        <div className='app'>
            <Game user={user}/>
            <div className='right'>
                <AboutMe />
                <User user={user} setUser={setUser} />
            </div>
        </div>
    )
}

export default App
