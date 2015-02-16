var App = React.createClass({displayName: "App",
  render: function () {
    if (this.state.login)
      return (
        React.createElement(Contacts, {getResults: this.getContacts})
      );
    else if (this.state.err)
      return (
        React.createElement("div", null, 
          React.createElement(Error, {err: this.state.err, status: this.state.status, alertType: "danger", onClosed: this.onAlertClosed}), 
          React.createElement(Screen, null), 
          React.createElement(LoginAndRegister, {onSubmit: this.handleSubmit})
        )
      );
    else
      return (
        React.createElement("div", null, 
          React.createElement(Screen, null), 
          React.createElement(LoginAndRegister, {onSubmit: this.handleSubmit})
        )
      );
  },
  getContacts: function () {

  },
  onAlertClosed: function () {
    this.setState({ err: null, status: null });
  },
  handleSubmit: function (url, auth) {
    $.ajax({
      url: url,
      dataType: 'json',
      type: 'POST',
      data: JSON.stringify(auth),
      success: function (data) {
        this.setState({ login: true });
      }.bind(this),
      error: function (xhr, status, err) {
        this.setState({ err: JSON.parse(xhr.response), status: status });
      }.bind(this)
    });
  },
  getInitialState: function () {
    return { 
      login: true,
      err: null,
      status: null
    };
  }
});
var LoginAndRegister = React.createClass({displayName: "LoginAndRegister",
  render: function () {
    return (
      React.createElement("div", {className: "row"}, 
        React.createElement("div", {className: "col-md-5"}, 
          React.createElement("form", {className: "form-horizontal"}, 
            React.createElement("div", {className: "form-group"}, 
              React.createElement("label", {htmlFor: "inputEmail3", className: "col-sm-2 control-label"}, "Email"), 
              React.createElement("div", {className: "col-sm-7"}, 
                React.createElement("input", {type: "email", className: "form-control", placeholder: "Email", ref: "email"})
              )
            ), 
            React.createElement("div", {className: "form-group"}, 
              React.createElement("label", {htmlFor: "inputPassword3", className: "col-sm-2 control-label"}, "Password"), 
              React.createElement("div", {className: "col-sm-7"}, 
                React.createElement("input", {type: "password", className: "form-control", placeholder: "Password", ref: "password"})
              )
            ), 
            React.createElement("div", {className: "form-group"}, 
              React.createElement("div", {className: "col-sm-offset-2 col-sm-10"}, 
                React.createElement("div", {className: "row"}, 
                  React.createElement("div", {className: "col-sm-2"}, 
                    React.createElement("input", {type: "submit", className: "btn btn-default", "data-url": "/login", onClick: this.onClick, value: "登录"})
                  ), 
                  React.createElement("div", {className: "col-sm-3"}, 
                    React.createElement("input", {type: "submit", className: "btn btn-primary", "data-url": "/register", onClick: this.onClick, value: "注册试用"})
                  )
                )
              )
            )
          )
        )
      )
    );
  },
  onClick: function (e) {
    e.preventDefault();
    this.onSubmit(e.target.dataset['url']);
  },  
  onSubmit: function (url) {
    var auth = {
      "email": this.refs.email.getDOMNode().value.trim(),
      "password": this.refs.password.getDOMNode().value.trim()
    };
    this.props.onSubmit(url, auth);
  }
});
var Contacts = React.createClass({displayName: "Contacts",
  render: function () {
    return (
      React.createElement("div", {className: "row"}, 
        React.createElement("div", {className: "col-md-12"}, 
          React.createElement("nav", {className: "navbar navbar-default"}, 
            React.createElement("div", {className: "container-fluid"}, 
              "// Brand and toggle get grouped for better mobile display", 
              React.createElement("div", {className: "navbar-header"}, 
                React.createElement("button", {type: "button", className: "navbar-toggle collapsed", "data-toggle": "collapse", "data-target": "#bs-example-navbar-collapse-1"}, 
                  React.createElement("span", {className: "sr-only"}, "Toggle navigation"), 
                  React.createElement("span", {className: "icon-bar"}), 
                  React.createElement("span", {className: "icon-bar"}), 
                  React.createElement("span", {className: "icon-bar"})
                ), 
                React.createElement("a", {className: "navbar-brand", href: "/"}, 
                  React.createElement("i", {className: "fa fa-git-square fa-2"})
                )
              ), 

              "// Collect the nav links, forms, and other content for toggling", 
              React.createElement("div", {className: "collapse navbar-collapse"}, 
                React.createElement("ul", {className: "nav navbar-nav"}, 
                  React.createElement("li", {className: "active"}, React.createElement("a", {href: "#"}, "Link ", React.createElement("span", {className: "sr-only"}, "(current)"))), 
                  React.createElement("li", null, React.createElement("a", {href: "#"}, "Link")), 
                  React.createElement("li", {className: "dropdown"}, 
                    React.createElement("a", {href: "#", className: "dropdown-toggle", "data-toggle": "dropdown", role: "button", "aria-expanded": "false"}, "Dropdown ", React.createElement("span", {className: "caret"})), 
                    React.createElement("ul", {className: "dropdown-menu", role: "menu"}, 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Action")), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Another action")), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Something else here")), 
                      React.createElement("li", {className: "divider"}), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Separated link")), 
                      React.createElement("li", {className: "divider"}), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "One more separated link"))
                    )
                  )
                ), 
                React.createElement("form", {className: "navbar-form navbar-left", role: "search"}, 
                  React.createElement("div", {className: "form-group"}, 
                    React.createElement("input", {type: "text", className: "form-control", placeholder: "Search"})
                  ), 
                  React.createElement("button", {type: "submit", className: "btn btn-default"}, 
                    React.createElement("i", {class: "fa fa-search fa-1"})
                  )
                ), 
                React.createElement("ul", {className: "nav navbar-nav navbar-right"}, 
                  React.createElement("li", null, React.createElement("a", {href: "#"}, "Link")), 
                  React.createElement("li", {className: "dropdown"}, 
                    React.createElement("a", {href: "#", className: "dropdown-toggle", "data-toggle": "dropdown", role: "button", "aria-expanded": "false"}, "Dropdown ", React.createElement("span", {className: "caret"})), 
                    React.createElement("ul", {className: "dropdown-menu", role: "menu"}, 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Action")), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Another action")), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Something else here")), 
                      React.createElement("li", {className: "divider"}), 
                      React.createElement("li", null, React.createElement("a", {href: "#"}, "Separated link"))
                    )
                  )
                )
              )
            )
          )
        )
      )
    );
  }
});
var Error = React.createClass({displayName: "Error",
  render: function () {
    return (
      React.createElement("div", {id: "alert", className: "alert alert-"+this.props.alertType+" alert-dismissible fade in", role: "alert"}, 
        React.createElement("button", {type: "button", className: "close", "data-dismiss": "alert", "aria-label": "Close"}, 
          React.createElement("span", {"aria-hidden": "true"}, "×")
        ), 
        React.createElement("strong", null, this.props.status), 
        React.createElement("p", null, this.props.err)
      )
    );
  },
  componentDidMount: function () {
    $('#alert').on('closed.bs.alert', this.props.onClosed);
  }
});
var Screen = React.createClass({displayName: "Screen",
  render: function () {
    return (
      React.createElement("div", {className: "row"}, 
        React.createElement("div", {className: "col-md-12"}, 
          React.createElement("div", {className: "jumbotron"}, 
            React.createElement("h1", null, React.createElement("i", {className: "fa fa-git-square fa-3"}), " Git Contacts"), 
            React.createElement("p", null, "在Git上搭建通讯录服务"), 
            React.createElement("p", {className: "text-right"}, 
              React.createElement("a", {className: "btn btn-primary btn-lg", href: "/inspect", role: "button"}, "了解它是如何工作的")
            )
          )
        )
      )
    );
  }
});

React.render(React.createElement(App, null), document.querySelector('#main'));