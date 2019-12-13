from kivy.app import App
from kivy.uix.button import Button


class OMSATApp(App):  #type: ignore
    def build(self) -> Button:
        return Button(text='hello world')