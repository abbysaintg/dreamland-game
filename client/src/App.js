import { BrowserRouter, Switch, Route } from "react-router-dom"
import './index.css'
import Game from "./Game.js"

function App() {

    return (
        <BrowserRouter>
            <div>
                <Switch>
                    <Route path='/'>
                        <Game />
                    </Route>
                    <Route path='/testing'>
                        <h1>Test Route</h1>
                    </Route>
                </Switch>
            </div>
        </BrowserRouter>
    )
}

export default App
