import { useState, useEffect } from "react"
import { BrowserRouter, Switch, Route } from "react-router-dom"
import './index.css'
import Game from "./Game.js"

function App() {
    // const [count, setCount] = useState(0)

    // useEffect(() => {
    //     fetch("/hello")
    //         .then((r) => r.json())
    //         .then((data) => setCount(data.count))
    // }, [])

    return (
        <BrowserRouter>
            <div>
                <Switch>
                    <Route path='/testing'>
                        <h1>Test Route</h1>
                    </Route>
                    <Route path='/'>
                        {/* <h1>Page Count: {count}</h1> */}
                        <Game />
                    </Route>
                </Switch>
            </div>
        </BrowserRouter>
    )
}

export default App
